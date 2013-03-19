class WishItemsController < ApplicationController
  def create
    wish_list = WishList.find_or_create_by_user_id_and_city_id(current_user.id, params[:city_id])
    wish_item = wish_list.wish_items.build(params[:wish_item])

    if wish_item.save
      render json: {
                     success: true,
                     wish_item_id: wish_item.id
                   }
    else
      render json: {
                     status: 422,
                     errors: "The item was unable to be added to your list."
                   }
    end
  end

  def destroy
    wish_item = WishItem.find(params[:id])
    wish_item.destroy
    render json: { success: true }
  end
end
