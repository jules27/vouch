class WishItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_list_owner_permissions,
                only: [:new_by_type, :destroy, :add_tagging, :delete_tagging]
  before_filter :check_view_permissions, only: [:get_tagging]

  def new_by_type
    @city = current_user.default_city
    @business_type = BusinessType.find(params[:type_id])
    @businesses = Business.find_all_by_business_type_id_and_city(@business_type.id, @city.name)

    @wish_list = WishList.find(params[:wish_list_id])
    @wish_item = WishItem.new
  end

  # Add a wish item from browsing the business#show page.
  # This is called by javascript.
  def create_independent
    if params[:wish_list_id].present?
      wish_list = WishList.find(params[:wish_list_id])
    else
      city_id = params[:city_id]
      wish_list = WishList.find_or_create_by_user_id_and_city_id(current_user.id, city_id)
    end

    wish_item = wish_list.wish_items.build(params[:wish_item])
    if wish_item.save
      # Create tags for this business: city, neighbor, category
      create_tagging_from_business(wish_item.id, params[:wish_item][:business_id])

      render json: { success: true }
    else
      render json: { errors: "Wish item was unable to be created." }
    end
  end

  # This method is called from a link as well as a javascript click.
  # html link: called from "Places I Want To Go", friends list, wish item
  # javascript click: from "My Friend's Vouches", vouch item
  def create
    city_id = params[:city_id] || params[:wish_item][:city_id]
    params[:wish_item].delete(:city_id) if params[:wish_item][:city_id].present?

    # Used by html call
    if params[:original_wish_item_id].present?
      original_wish_item = WishItem.find(params[:original_wish_item_id])
    end

    # Used by javascript call
    if params[:vouch_item_id].present?
      tags = []
      vouch_item = VouchItem.find(params[:vouch_item_id])
      vouch_item.tags.each do |tag|
        tags.push(tag.name)
      end
    end

    wish_list = WishList.find_or_create_by_user_id_and_city_id(current_user.id, city_id)
    wish_item = wish_list.wish_items.build(params[:wish_item])
    puts "add item for business #{wish_item.business_id}"

    if wish_item.save
      respond_to do |format|
        # Add taggings from original wish item to new wish item
        if original_wish_item.present?
          original_wish_item.wish_taggings.each do |tagging|
            add_tagging_with_params(id: wish_item.id, name: tagging.tag.name)
          end
        end

        format.html {
                      flash[:notice] = "The item has been successfully added to your wish list!"
                      redirect_to wish_lists_path
                    }
        format.json {
                      render json:
                        {
                          success: true,
                          wish_item_id: wish_item.id,
                          tags: tags
                        }
                    }
      end
    else
      respond_to do |format|
        format.html {
                      flash[:alert] = wish_item.errors.full_messages
                      redirect_to wish_lists_path
                    }
        format.json {
                      render json:
                        {
                          status: 422,
                          errors: wish_item.errors.full_messages.join(",")
                        }
                    }
      end
    end
  end

  def destroy
    wish_item = WishItem.find(params[:id])
    wish_item.destroy
    render json: { success: true }
  end

  def visited
    wish_item  = WishItem.find(params[:id])
    vouch_list = current_user.vouch_list_primary

    tags = []
    wish_item.tags.each do |tag|
      tags.push(tag.name)
    end

    # Add this item to vouch list and remove it from this wish list
    vouch_item = vouch_list.vouch_items.build(business_id: wish_item.business_id)
    unless vouch_item.save
      render json: {
                     status: 422,
                     errors: "The list with item \"#{vouch_item.business.name}\" was unable to be saved."
                   }
      return
    end

    wish_item.destroy

    render json: {
                   success: true,
                   vouch_item_id: vouch_item.id,
                   tags: tags
                 }
  end

  def get_tagging
    wish_item = WishItem.find(params[:id])
    render json: {
                   tags: wish_item.tags
                 }
  end

  def add_tagging
    result = add_tagging_with_params(params)

    if result == true
      respond_to do |format|
        format.html {
          # Tell the engine to not render any pages. Otherwise, the
          # javascript caller will get a 500 error saying add_tagging.html
          # cannot be rendered.
          render nothing: true
        }
        format.json {
          render json: { success: true }
        }
      end
    else
      respond_to do |format|
        format.html {
          render nothing: true
        }
        format.json {
          render json: {
                       status: 422,
                       errors: "The tag was unable to be saved."
                     }
        }
      end
    end
  end

  # This actual tag-adding method can be called by two places:
  # 1. From add_tagging, which is called when the user adds tags to
  #    a wish item, on the user's Places I Want To Go page.
  # 2. From create, which is called when a new wish item is added.
  def add_tagging_with_params(p = {})
    wish_item  = WishItem.find(p[:id])
    tag        = Tag.find_or_create_by_name(p[:name])

    # Create entry in tagging join table
    tagging    = WishTagging.new(wish_item_id: wish_item.id,
                                 tag_id: tag.id)

    if tagging.save
      respond_to do |format|
        format.html {
          return true
        }
        format.json {
          return true
        }
      end
    else
      respond_to do |format|
        format.html {
          return false
        }
        format.json {
          return false
        }
      end
    end
  end

  def delete_tagging
    wish_item  = WishItem.find(params[:id])
    tag        = Tag.find_by_name(params[:name])

    if wish_item.nil? or tag.nil?
      render json: { status: 422 }
      return
    end

    tagging    = WishTagging.find_by_wish_item_id_and_tag_id(wish_item.id, tag.id)
    tagging.destroy
    render json: { success: true }
  end

  private

  def check_list_owner_permissions
    wish_item = WishItem.find(params[:id]) if params[:id].present?
    wish_list = wish_item.present? ? wish_item.wish_list : WishList.find(params[:wish_list_id])
    unless current_user.id == wish_list.user.id or current_user.admin?
      redirect_to wish_lists_path,
                  flash: {
                           error: "You do not have the permission to do this."
                         }
    end
  end

  def check_view_permissions
    # Can the current user view tags for this wish item?
    # Yes only if the list's owner is friends with the current user.
    wish_item = WishItem.find(params[:id])
    wish_list = wish_item.wish_list
    if (!current_user.admin?) and (wish_list.user.id != current_user.id)
      has_match = false
      current_user.friends.each do |friend|
        has_match = true if friend.id == wish_list.user.id
      end
      if has_match == false
        redirect_to root_path,
                    flash: {
                             error: "You do not have the permission to view this list."
                           }
      end
    end
  end

  # Create tagging for a wish item based on business information.
  # Tagging for city, neighborhoods, and categories.
  def create_tagging_from_business(wish_item_id, business_id)
    business = Business.find(business_id)

    city_tag = Tag.find_or_create_by_name(business.city.downcase)
    WishTagging.create(wish_item_id: wish_item_id, tag_id: city_tag.id)

    business.neighborhood.split(",").each do |neighborhood|
      neighborhood_tag = Tag.find_or_create_by_name(neighborhood.downcase)
      WishTagging.create(wish_item_id: wish_item_id, tag_id: neighborhood_tag.id)
    end

    business.categories_formatted.split(",").each do |category|
      category_tag = Tag.find_or_create_by_name(category.downcase)
      WishTagging.create(wish_item_id: wish_item_id, tag_id: category_tag.id)
    end
  end
end
