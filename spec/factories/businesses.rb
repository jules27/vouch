require 'faker'

FactoryGirl.define do
  neighborhoods = %w( neighborhood1 neighborhood2 neighborhood3 neighborhood4)
  categories    = %w( category1 category2 category3 category4)

  factory :business do
    business_type_id 1
    name  { Faker::Company.name + " Restaurant" }
    phone { "555-123-1234" }
    address_line_1 { Faker::Address.street_address }
    city  { "San Francisco" } # default
    state { "CA" } # default
    zip   { Faker::Address.zip_code }
    neighborhood { neighborhoods.sample(rand(neighborhoods.size)).join(",") }
    categories   { categories.sample(1 + rand(categories.size)).join("|") }

    yelp_id { |b| b.name.split(" ").map {|w| w.downcase}.join("-") }
    yelp_rating { 3 + rand(5) }
    yelp_review_count { 10 + rand(1000) }

    latitude  { Faker::Address.latitude }
    longitude { Faker::Address.longitude }

    image_url ""
  end
end