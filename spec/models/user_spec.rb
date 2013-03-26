require 'spec_helper'

describe User do
  before :each do
    basic_test_data
  end

  context "#check_current_shared_lists" do
    it "Creates a friendship between user and shared friend" do
      # Create a vouch list under the admin user.
      # Share the list to email 'a@example.com'
      # Create a user under the same email and make sure these two become
      # friends with each other.
      admin = User.find(1)
      vouch_list = FactoryGirl.create(:vouch_list,
                                      owner_id: admin.id,
                                      city_id:  admin.city.id)
      share_friend_email = "share@test.com"
      FactoryGirl.create(:shared_friend,
                         vouch_list_id: vouch_list.id,
                         email: share_friend_email)

      friend = FactoryGirl.create(:user,
                                  city_id: admin.city.id,
                                  email:   share_friend_email)

      admin_friend = Friendship.find_by_user_id_and_friend_id(admin.id, friend.id)
      friend_admin = Friendship.find_by_user_id_and_friend_id(friend.id, admin.id)

      admin_friend.should_not be_nil
      friend_admin.should_not be_nil
    end
  end
end
