class VouchListsController < ApplicationController
  def new
    restaurants = Business.find_all_by_city("San Francisco")
    render 'new', locals: { restaurants: restaurants }
  end

  def create
    @vouch_list = VouchList.new(params[:vouch_list])
    unless @vouch_list.save
      render json: {
                     status: 422,
                     errors: "The list was unable to be created."
                   }
      return
    end

    # List was created, let's create items under this list
    params[:vouch_items].each do |item|
      vouch_item = @vouch_list.vouch_items.build(item.second)

      unless vouch_item.save
        business = Business.find(item.second[:business_id])
        render json: {
                       status: 422,
                       errors: "The list with item \"#{business.name}\" was unable to be saved."
                     }
        return
      end
    end

    render json: {
                   success: true,
                   list_id: @vouch_list.id
                 }
  end

  def show
    @vouch_list = VouchList.find(params[:id])
  end
end
