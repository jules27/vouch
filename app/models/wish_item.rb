class WishItem < ActiveRecord::Base
  belongs_to :wish_list
  belongs_to :business
  belongs_to :user # Friend who inspired

  # TODO: add taggings

  attr_accessible :wish_list_id, :business_id, :user_id

  validates_presence_of :wish_list_id, :business_id, :user_id
end
