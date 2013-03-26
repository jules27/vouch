require 'spec_helper'

describe VouchListsController do
  render_views

  before :each do
    basic_test_data
    user = User.first

    # Make some lists for this user
    sf = City.find_by_name("San Francisco")
    FactoryGirl.create(:vouch_list,
                       owner_id: user.id,
                       city_id:  sf.id)
  end

  context "#index" do
    it "does not show list when user is not logged in" do
      visit "/vouch_lists"
      page.should have_content "You need to sign in"
    end

    it "lists my vouch list in the correct city" do
      user = User.first
      login_as(user, scope: :user)

      visit "/vouch_lists"
      page.should have_content "in San Francisco"
    end

    it "lists my vouch list in the correct city after changing the default city" do
      user = User.first
      ch = City.find_by_name("Chicago")
      user.set_default_city(ch)
      login_as(user, scope: :user)

      visit "/vouch_lists"
      page.should have_content "in Chicago"
    end
  end
end
