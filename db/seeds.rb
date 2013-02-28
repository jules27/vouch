# Create admin user
# User.create(first_name: "Julie", last_name: "Mao", email: "julie@sandboxindustries.com",
#             password: "password", password_confirmation: "password",
#             admin: true)

# Create restaurant category
restaurant_type = BusinessType.find_by_name("restaurant")

# # Create restaurants from Yelp
latitude  = 37.77509
longitude = -122.39832

results = YelpHelper.search("#{latitude},#{longitude}")
puts "***** # of results = #{results.count}"
results.each do |restaurant|
  existing_restaurant = Business.find_by_name_and_latitude_and_longitude(
                                    restaurant[:name],
                                    restaurant[:latitude],
                                    restaurant[:longitude])
  if existing_restaurant.present?
    puts "***** Restaurant exists in database: #{restaurant[:name]}"
    existing_restaurant.update_attributes(restaurant.except(:distance, :yelp_url))
  else
    puts "***** Create new restaurant: #{restaurant[:name]}"
    restaurant[:business_type_id] = restaurant_type.id
    b = Business.create!(restaurant.except(:distance, :yelp_url))
    puts "      added restaurant! #{b.name} in #{b.city}"
  end
end
