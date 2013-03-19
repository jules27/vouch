class WishList < ActiveRecord::Base
  belongs_to :user
  belongs_to :city
  has_many   :wish_items
  has_many   :businesses, through: :wish_items

  attr_accessible :user_id, :city_id

  validates_presence_of :user_id, :city_id
end
