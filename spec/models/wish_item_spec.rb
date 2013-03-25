require 'spec_helper'

describe WishItem do
  before :each do
    basic_test_data
  end

  context "#no_duplicate_items_in_list" do
    it "Does not create a wish item with the same business as an existing vouch item in a vouch list" do
      admin = User.find(1)
      vouch_list = FactoryGirl.create(:vouch_list_simple,
                                      owner_id: admin.id,
                                      city_id:  admin.city.id)
      wish_list = FactoryGirl.create(:wish_list_simple,
                                      user_id:  admin.id,
                                      city_id:  admin.city.id)

      # Pick a random business
      business   = Business.all.sample(1).first
      vouch_item = FactoryGirl.create(:vouch_item,
                                      vouch_list_id: vouch_list.id,
                                      business_id: business.id)

      # Try creating a wish item. It should fail
      wish_item  = FactoryGirl.build(:wish_item,
                                      wish_list_id: wish_list.id,
                                      business_id: business.id)

      wish_item.valid?.should be false
    end
  end
end
