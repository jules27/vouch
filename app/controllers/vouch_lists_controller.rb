class VouchListsController < ApplicationController
  def index
    @vouch_lists = VouchList.find_all_by_owner_id(current_user.id)
  end

  def show
    @vouch_list = VouchList.find(params[:id])
  end

  def show_with_token
    @vouch_list = VouchList.find(params[:vouch_list_id])

    unless cookies[:google_auth].present?
      expire_hours = params[:expires_in].to_i / 3600 # originally in seconds
      cookies[:google_auth] =
        {
          value:   params[:access_token],
          expires: expire_hours.hour.from_now
        }
      cookies[:google_token_type] =
        {
          value:   params[:token_type],
          expires: expire_hours.hour.from_now
        }
    end

    redirect_to "/vouch_lists/#{@vouch_list.id}",
                flash: {
                         auth_provider: "google"
                       }
  end

  # Default new now set to SF. Can deprecate later or change
  # to all citities (slow load time?)
  def new
    city = City.find_by_name("San Francisco")
    restaurants = Business.find_all_by_city(city.name)
    render 'new', locals: {
                            vouch_list:  nil,
                            city: city,
                            restaurants: restaurants
                          }
  end

  def new_by_city
    city = City.find_by_name(params[:city])
    restaurants = Business.find_all_by_city(city.name)
    render 'new', locals: {
                            vouch_list:  nil,
                            city: city,
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
    city = City.find_by_name(@vouch_list.city.name || "San Francisco")
    restaurants = Business.find_all_by_city(city.name)

    render 'new', locals: {
                            vouch_list:  @vouch_list,
                            city: city,
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

  def share_email
    # Invoke mailer
    vouch_list = VouchList.find(params[:id])
    VouchListMailer.share_vouch(params[:email], vouch_list, request.protocol + request.host_with_port).deliver
    render json: {
                   success: true
                 }
  end

end
