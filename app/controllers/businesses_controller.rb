class BusinessesController < ApplicationController
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
       name = get_data_from_yelp(@business, @business_type)

      flash[:notice] = "New #{@business_type.name} \"#{name}\" was successfully created."
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
    add_to_database(results, type)

    # Return the name of the first business added for flash message
    results.first[:name]
  end

  def add_to_database(results, type)
    results.each do |restaurant|
      existing_restaurant = Business.find_by_name_and_latitude_and_longitude(
                                        restaurant[:name],
                                        restaurant[:latitude],
                                        restaurant[:longitude])
      if existing_restaurant.present?
        puts "Restaurant exists in database: #{restaurant[:name]}"
        existing_restaurant.update_attributes(restaurant.except(:distance, :yelp_url))
      else
        puts "Creating a new restaurant..."
        restaurant[:business_type_id] = type.id
        b = Business.create!(restaurant.except(:distance, :yelp_url))
        puts "     ...added restaurant! #{b.name} in #{b.city}"
      end
    end
  end

end
