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
    if params[:wish_item][:city_id].present?
      params[:wish_item].delete(:city_id)
    end

    wish_list = WishList.find_or_create_by_user_id_and_city_id(current_user.id, city_id)
    wish_item = wish_list.wish_items.build(params[:wish_item])
    puts "add item for business #{wish_item.business_id}"

    if wish_item.save
      respond_to do |format|
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

    render json: { success: true }
  end
end
