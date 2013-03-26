require 'spec_helper'

describe WishListsController do
  render_views

  before :each do
    basic_test_data
    @sf   = City.find_by_name("San Francisco")
    @user = User.first
    my_list = FactoryGirl.create(:wish_list_simple,
                                 user_id: @user.id, city_id: @sf.id)
    FactoryGirl.create(:wish_item,
                       wish_list_id: my_list.id,
                       business_id: Business.first.id)

    # Create a friend
    @friend1 = FactoryGirl.create(:user,
                                  city_id: @sf.id,
                                  first_name: "Alice", last_name: "Amy")
    FactoryGirl.create(:friendship,
                       user_id: @sf.id, friend_id: @friend1.id)
    @friend1_list = FactoryGirl.create(:wish_list_simple,
                                       user_id: @friend1.id, city_id: @sf.id)

    @friend2 = FactoryGirl.create(:user, city_id: @sf.id, first_name: "Bob", last_name: "Bruce")
    @friend2_list = FactoryGirl.create(:wish_list_simple,
                                       user_id: @friend2.id, city_id: @sf.id)
  end

  context "#index" do
    it "does not show wish lists when user is not logged in" do
      visit "/wish_lists"
      page.should have_content "You need to sign in"
    end

    it "shows my wish list" do
      login_as(@user, scope: :user)

      visit "/wish_lists"
      page.should have_content "Places I Want To Go In #{@sf.name}"
    end

    it "shows my friend's wish lists in the correct city" do
      businesses = Business.find_all_by_city(@sf.name)
      FactoryGirl.create(:wish_item,
                       wish_list_id: @friend1_list.id,
                       business_id: businesses.pop.id)
      FactoryGirl.create(:wish_item,
                       wish_list_id: @friend2_list.id,
                       business_id: businesses.pop.id)

      login_as(@user, scope: :user)

      visit "/wish_lists"
      page.should have_content("Places #{@friend1.name} Wants To Go In #{@sf.name}")
      page.should_not have_content("Places #{@friend2.name} Wants To Go In #{@sf.name}")
    end

    it "shows my friend's wish lists after default city has changed" do
      ch = City.find_by_name("Chicago")
      @user.set_default_city(ch)
      businesses = Business.find_all_by_city(ch.name)

      my_list = FactoryGirl.create(:wish_list_simple,
                                   user_id: @user.id, city_id: ch.id)
      FactoryGirl.create(:wish_item,
                         wish_list_id: my_list.id,
                         business_id: businesses.pop.id)

      friend1_list = FactoryGirl.create(:wish_list_simple,
                                        user_id: @friend1.id, city_id: ch.id)
      FactoryGirl.create(:wish_item,
                         wish_list_id: friend1_list.id,
                         business_id: businesses.pop.id)

      friend2_list = FactoryGirl.create(:wish_list_simple,
                                        user_id: @friend2.id, city_id: ch.id)
      FactoryGirl.create(:wish_item,
                         wish_list_id: friend2_list.id,
                         business_id: businesses.pop.id)

      login_as(@user, scope: :user)

      visit "/wish_lists"
      page.should have_content("Places #{@friend1.name} Wants To Go In #{ch.name}")
      page.should_not have_content("Places #{@friend2.name} Wants To Go In #{ch.name}")
    end
  end
end
