class VouchList < ActiveRecord::Base
  include PgSearch

  belongs_to :owner, class_name: "User"
  belongs_to :city
  has_many   :vouch_items
  has_many   :businesses, through: :vouch_items
  has_many   :tags, through: :vouch_items
  has_many   :shared_friends

  attr_accessible :owner_id, :title, :description, :status, :city_id

  accepts_nested_attributes_for :vouch_items, allow_destroy: true
  attr_accessible :vouch_items_attributes

  validates_presence_of :owner_id, :title, :city_id

  before_validation :set_default_title
  before_create     :set_defaults

  # Search through associations
  pg_search_scope :name_search, associated_against: {
    businesses: :name,
    tags:       :name
  }

  # Return a list of items with certain attributes selected
  def items_formatted
    items = Array.new
    vouch_items.each do |item|
      new_item = Hash.new
      business = Business.find(item.business_id)
      new_item["id"]   = item.business_id
      new_item["name"] = business.name
      new_item["neighborhood"] = business.neighborhood
      new_item["city"] = business.city
      new_item["yelp_rating"]  = business.yelp_rating
      new_item["yelp_reviews"] = business.yelp_review_count
      new_item["item_id"] = item.id

      items << new_item
    end
    items
  end

  def my_list?(user)
    user.id == self.owner.id
  end

  def empty?
    vouch_items.count == 0
  end

  private

  def set_default_title
    self.title = "#{self.owner.first_name}'s Favorite Restaurants in #{self.city.name}"
  end

  def set_defaults
    self.status = "pending"
    self.title ||= "Favorite restaurants for a sunny company outing"
  end
end
