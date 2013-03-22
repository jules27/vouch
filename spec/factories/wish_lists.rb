# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wish_list do
    user_id  1 # This needs to be passed in
    city_id  1 # This needs to be passed in

    # Add some items to this list
    after(:create) do |list|
      3.times do
        # Pick a random business to add in the city
        business = Business.find_all_by_city(list.city.name).sample(1).first
        FactoryGirl.create(:wish_item,
                           wish_list_id: list.id,
                           business_id:  business.id)
      end
    end
  end

  factory :wish_list_simple, class: WishList do
    user_id  1 # This needs to be passed in
    city_id  1 # This needs to be passed in
  end

  factory :wish_item do
    wish_list_id 1 # This should be passed in
    business_id  1 # This should be passed in

    # Add some tags to this item
    after(:create) do |item|
      3.times do
        FactoryGirl.create(:wish_tagging,
                           tag_id: Tag.all.sample(1).first.id,
                           wish_item_id: item.id)
      end
    end
  end
end
