class SharedFriend < ActiveRecord::Base
  belongs_to :vouch_list

  attr_accessible :vouch_list_id, :user_id, :email, :name, :facebook_id
end
