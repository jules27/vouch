require 'spec_helper'

describe FriendsController do
  render_views

  before :each do
    basic_test_data
    @sf   = City.find_by_name("San Francisco")
    @user = User.first

    # Create a friend
    @friend1 = FactoryGirl.create(:user,
                                  city_id: @sf.id,
                                  first_name: "Alice", last_name: "Amy")
    FactoryGirl.create(:friendship,
                       user_id: @sf.id, friend_id: @friend1.id)
    FactoryGirl.create(:vouch_list,
                       owner_id: @friend1.id, city_id: @sf.id)

    @friend2 = FactoryGirl.create(:user, city_id: @sf.id, first_name: "Bob", last_name: "Bruce")
    FactoryGirl.create(:vouch_list,
                       owner_id: @friend2.id, city_id: @sf.id)
  end

  context "#index" do
    it "does not show friends' lists when user is not logged in" do
      visit "/friends"
      page.should have_content "You need to sign in"
    end

    it "shows my friend's vouch list" do
      login_as(@user, scope: :user)

      # Should only have friends' lists
      visit "/friends"
      page.should have_content("#{@friend1.first_name}'s Favorite Restaurants in #{@sf.name}")
      page.should_not have_content("#{@friend2.first_name}'s Favorite Restaurants in #{@sf.name}")
    end

    it "shows my friend's vouch list after default city has changed" do
      ch = City.find_by_name("Chicago")
      @user.set_default_city(ch)

      FactoryGirl.create(:vouch_list,
                       owner_id: @friend1.id, city_id: ch.id)
      FactoryGirl.create(:vouch_list,
                       owner_id: @friend2.id, city_id: ch.id)

      login_as(@user, scope: :user)

      # Should only have friends' lists
      visit "/friends"
      page.should have_content("#{@friend1.first_name}'s Favorite Restaurants in #{ch.name}")
      page.should_not have_content("#{@friend2.first_name}'s Favorite Restaurants in #{ch.name}")
    end
  end

end
