namespace :yelp do
  desc "Retrieve restaurants using Yelp's API"
  task :restaurants => :environment do
    restaurant_type = BusinessType.find_by_name("restaurant")
    unless restaurant_type.present?
      puts "Business type restaurant is not available. Please create one."
      return
    end

    # Set latitude & longitude from environment variables
    location =  Settings.yelp_location

    results = YelpHelper.search(location)
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
        puts "Creating a new restaurant..."
        restaurant[:business_type_id] = restaurant_type.id
        b = Business.create!(restaurant.except(:distance, :yelp_url))
        puts "     ...added restaurant! #{b.name} in #{b.city}"
      end
    end
  end
end