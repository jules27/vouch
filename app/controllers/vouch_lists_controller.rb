class VouchListsController < ApplicationController
  def new
    restaurants = Business.find_all_by_city("San Francisco")
    render 'new', locals: { restaurants: restaurants }
  end

  def create
    puts "***********"
    puts params

    @vouch_list = VouchList.new(params[:vouch_list])
    # TODO: test this
    unless @vouch_list.save
      render json: {
                     status: 422,
                     errors: "The list was unable to be created."
                   }
    end

    # List was created, let's create items under this list
    params[:vouch_items].each do |item|
      vouch_item = @vouch_list.vouch_items.build(item.second)

      # TODO: test this
      unless vouch_item.save
        business    = Business.find(item.second.id)
        render json: {
                       status: 422,
                       errors: "The item with business #{business.name} was unable to be saved."
                     }
      end
    end

    render json: { success: true }
  end

  def show
    @vouch_list = VouchList.find(params[:id])
  end
end
