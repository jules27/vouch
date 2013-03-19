class WishItemsController < ApplicationController
  def create
    wish_list = WishList.find_or_create_by_user_id_and_city_id(current_user.id, params[:city_id])
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
    wish_item = WishItem.find(params[:id])

    # Add this item to vouch list and remove it from this wish list

    render json: { success: true }
  end
end
