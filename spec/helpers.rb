module Helpers
  def login(city = City.first)
    user = FactoryGirl.create(:user, city_id: city.id)
    login_as(user, scope: :user)
  end

  # Basic database setup, similar to the seed file
  def basic_test_data
    sf = FactoryGirl.create(:city, name: "San Francisco")
    ch = FactoryGirl.create(:city, name: "Chicago")
    FactoryGirl.create(:business_type)

    # Admin user
    FactoryGirl.create(:user, admin: true, city_id: sf.id)

    # Need some businesses in each city
    3.times do
      FactoryGirl.create(:business, city: sf.name, state: "CA")
      FactoryGirl.create(:business, city: ch.name, state: "IL")
    end

    %w(a b c d e f g h i j k).each do |tag|
      FactoryGirl.create(:tag, name: tag)
    end
  end
end