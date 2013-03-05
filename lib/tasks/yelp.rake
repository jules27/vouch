namespace :yelp do
  desc "Retrieve restaurants using Yelp's API"
  task :restaurants => :environment do
    restaurant_type = BusinessType.find_by_name("restaurant")
    unless restaurant_type.present?
      puts "Business type restaurant is not available. Please create one."
      return
    end

    # Set latitude & longitude
    # SF
    # latitude  = 37.77509
    # longitude = -122.39832

    # Chicago
    # latitude = 41.885978
    # longitude = -87.656687

    # Get from settings
    latitude  = Settings.yelp_latitude.to_f
    longitude = Settings.yelp_longitude.to_f

    results = YelpHelper.search("#{latitude},#{longitude}")
    puts "Number of results: #{results.count}"
    results.each do |restaurant|
      existing_restaurant = Business.find_by_name_and_latitude_and_longitude(
                                        restaurant[:name],
                                        restaurant[:latitude],
                                        restaurant[:longitude])
      if existing_restaurant.present?
        puts "Restaurant exists in database: #{restaurant[:name]}"
        existing_restaurant.update_attributes(restaurant.except(:distance, :yelp_url))
      else
        puts "Creating a new restaurant: #{restaurant[:name]}"
        restaurant[:business_type_id] = restaurant_type.id
        b = Business.create!(restaurant.except(:distance, :yelp_url))
        puts "     ...added restaurant! #{b.name} in #{b.city}"
      end
    end
  end
end