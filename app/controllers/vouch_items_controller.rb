class VouchItemsController < ApplicationController
  def create
    vouch_list = VouchList.find(params[:id])
    vouch_item = vouch_list.vouch_items.build(params[:vouch_item])
    if vouch_item.save
      render json: { success: true }
    else
      render json: {
                     status: 422,
                     errors: "The list was unable to be created."
                   }
    end
  end

  def destroy
    vouch_item = VouchItem.find(params[:id])
    vouch_item.destroy
    render json: { success: true }
  end
end
