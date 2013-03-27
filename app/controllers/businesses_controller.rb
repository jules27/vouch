class BusinessesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @businesses = Business.order("lower(name) ASC").find_all_by_city(current_user.default_city.name)
  end

  def show
    @business = Business.find(params[:id])
  end

  def details
    @business = Business.find_by_name_and_city(params[:name], params[:city])

    respond_to do |format|
      format.json do
        if @business.present?
          render json: { success: true,
                         business: @business }
        else
          render json: {
                         status: 422,
                         errors: "Unable to find business named \"#{params[:name]}\" in #{params[:city]}."
                       }
        end
      end
    end
  end

  def new_by_type
    @business = Business.new
    @business_type = BusinessType.find_by_name(params[:type])
    render action: "new_by_type",
           locals: {
                     business: @business,
                     business_type: @business_type
                   }
  end

  # Instead of creating a new business, do a lookup on Yelp and add all results
  # to the database.
  def create
    @business = Business.new(params[:business])
    @business_type = BusinessType.find(params[:business][:business_type_id])

    if params[:business][:business_type_id].present? and
       params[:business][:name].present? and
       params[:business][:city].present? and
       params[:business][:state].present?
      first_business = get_data_from_yelp(@business, @business_type)

      if params[:add_to_list].present?
        add_item_to_list(params[:add_to_list], first_business)
      end

      flash[:notice] = "New #{@business_type.name} \"#{first_business.name}\" was successfully created."
      redirect_to vouch_lists_path
    else
      flash[:error]  = "Please enter the name, city, and state."
      redirect_to new_business_by_type_path(@business_type.name)
    end
  end

  private

  def get_data_from_yelp(business, type)
    results = YelpHelper.search_for_business(type.name,
                                             business.name,
                                             business.city,
                                             business.state)
    businesses = add_to_database(results, type)

    # Return the first business added
    businesses.first
  end

  def add_to_database(results, type)
    businesses = []
    results.each do |restaurant|
      existing_restaurant = Business.find_by_name_and_latitude_and_longitude(
                                        restaurant[:name],
                                        restaurant[:latitude],
                                        restaurant[:longitude])
      if existing_restaurant.present?
        puts "Restaurant exists in database: #{restaurant[:name]}"
        existing_restaurant.update_attributes(restaurant.except(:distance, :yelp_url))
        businesses.push(existing_restaurant)
      else
        puts "Creating a new restaurant..."
        restaurant[:business_type_id] = type.id
        b = Business.create(restaurant.except(:distance, :yelp_url))
        puts "     ...added restaurant! #{b.name} in #{b.city}"
        businesses.push(b)
      end
    end
    businesses
  end

  def add_item_to_list(list_type, business)
    city = City.find_by_name(business.city)
    # Cannot add the item to list if the city is not in the system yet
    return if city.nil?

    case list_type
    when "vouch_list"
      list = current_user.vouch_lists_by_city(city.name).first
      item = list.vouch_items.build(business_id: business.id)
      item.save
    when "wish_list"
      list = current_user.wish_list_in_city(city)
      item = list.wish_items.build(business_id: business.id)
      item.save
    end
  end
end
