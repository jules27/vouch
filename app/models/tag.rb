class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :vouch_items, through: :taggings

  attr_accessible :name
end
