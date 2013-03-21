class WishItemsController < ApplicationController
  def new_by_type
    @city = current_user.default_city
    @business_type = BusinessType.find(params[:type_id])
    @businesses = Business.find_all_by_business_type_id_and_city(@business_type.id, @city.name)

    @wish_list = WishList.find(params[:wish_list_id])
    @wish_item = WishItem.new
  end

  def create
    city_id = params[:city_id] || params[:wish_item][:city_id]
    params[:wish_item].delete(:city_id) if params[:wish_item][:city_id].present?

    if params[:original_wish_item_id].present?
      original_wish_item = WishItem.find(params[:original_wish_item_id])
    end

    wish_list = WishList.find_or_create_by_user_id_and_city_id(current_user.id, city_id)
    wish_item = wish_list.wish_items.build(params[:wish_item])
    puts "add item for business #{wish_item.business_id}"

    # This method is called from a link as well as a javascript click.
    # html link: called from "Places I Want To Go", friends list, wish item
    # javascript click: from "My Friend's Vouches", vouch item
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
                          wish_item_id: wish_item.id
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
          render json: { success: true }
        }
      end
    else
      respond_to do |format|
        format.html {
          return false
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
end
