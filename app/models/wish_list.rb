class WishList < ActiveRecord::Base
  include PgSearch

  belongs_to :user
  belongs_to :city
  has_many   :wish_items, dependent: :destroy
  has_many   :businesses, through: :wish_items
  has_many   :tags, through: :wish_items

  attr_accessible :user_id, :city_id

  validates_presence_of :user_id, :city_id

  # Search through associations
  pg_search_scope :name_search, associated_against: {
    businesses: :name,
    tags:       :name
  }, using:{tsearch: {dictionary: "english"}}

  def empty?
    self.nil? or wish_items.empty?
  end

  def has_item?(item)
    wish_items.where(business_id: item.business.id).count > 0
  end

  def has_business?(business)
    businesses.where(id: business.id).count > 0
  end
end
