class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :vouch_items, through: :taggings

  attr_accessible :name

  validates_presence_of   :name
  validates_uniqueness_of :name
end
