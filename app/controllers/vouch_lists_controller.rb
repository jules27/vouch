class VouchListsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_permissions, only: [:edit]

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

  def new_by_city
    city = City.find_by_name(params[:city])

    # Before making a new one, see if one with the same city already exists
    list_for_city = current_user.vouch_lists.find_by_city_id(city.id)
    if list_for_city.present?
      redirect_to edit_vouch_list_path(list_for_city)
      return
    end

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
                            vouch_items: @vouch_list.vouch_items,
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

  def add_shared_friend
    vouch_list = VouchList.find(params[:id])
    user_id    = User.find_by_email(params[:name], params[:email])

    shared_friend = vouch_list.shared_friends.build(
                                                    user_id: user_id,
                                                    email: params[:email],
                                                    name:  params[:name],
                                                    facebook_id: params[:facebook_id]
                                                   )
    if shared_friend.save
      render json: {
                     success: true
                   }
    else
      render json: {
                     status: 422,
                     errors: "The shared friend was unable to be saved."
                   }
      return
    end
  end

  def delete_shared_friend
    #TODO
  end

  private

  def check_permissions
    vouch_list = VouchList.find(params[:id])
    unless current_user.id == vouch_list.owner.id
      redirect_to vouch_list,
                  flash: {
                           error: "You do not have the permission to do this."
                         }
    end
  end

end
