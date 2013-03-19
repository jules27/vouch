FactoryGirl.define do
  factory :vouch_list do
    owner_id 1 # This needs to be passed in
    title "Test User Title" # This should also be passed in
    city_id  1 # This needs to be passed in

    # Add some items to this list
    after(:create) do |list|
      3.times do
        # Pick a random business to add in the city
        business = Business.find_all_by_city(list.city.name).sample(1).first
        FactoryGirl.create(:vouch_item,
                           vouch_list_id: list.id,
                           business_id:   business.id)
      end
    end
  end

  factory :vouch_item do
    vouch_list_id 1 # This should be passed in
    business_id   1 # This should be passed in

    # Add some tags to this item
    after(:create) do |item|
      3.times do
        FactoryGirl.create(:tagging,
                           tag_id: Tag.all.sample(1).first.id,
                           vouch_item_id: item.id)
      end
    end
  end
end
