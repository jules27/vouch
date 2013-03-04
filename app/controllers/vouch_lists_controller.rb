class VouchListsController < ApplicationController
  def index
    @vouch_lists = VouchList.find_all_by_owner_id(current_user.id)
  end

  def show
    @vouch_list = VouchList.find(params[:id])
  end

  def new
    restaurants = Business.find_all_by_city("San Francisco")
    render 'new', locals: {
                            vouch_list:  nil,
                            restaurants: restaurants
                          }
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

  def update
    @vouch_list = VouchList.find(params[:id])
    unless @vouch_list.update_attributes(params[:vouch_list])
      render json: {
                     status: 422,
                     errors: "The list was unable to be created."
                   }
      return
    end

    # Note: Updating items in the list is done through ajax as each item is added/removed

    render json: {
                   success: true
                 }
  end

  def edit
    @vouch_list = VouchList.find(params[:id])
    restaurants = Business.find_all_by_city("San Francisco")

    render 'new', locals: {
                            vouch_list:  @vouch_list,
                            restaurants: restaurants
                          }
  end

  def destroy
    vouch_list = VouchList.find(params[:id])
    vouch_list.destroy

    redirect_to vouch_lists_path, notice: "List has been deleted."
  end

  # Used to load and initialize data for data-binding
  def details
    @vouch_list = VouchList.find(params[:id])
    render json: {
                   title: @vouch_list.title,
                   items: @vouch_list.items_formatted
                 }
  end

end
