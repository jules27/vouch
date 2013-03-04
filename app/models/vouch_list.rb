class VouchList < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  has_many   :vouch_items

  attr_accessible :owner_id, :title, :description, :status

  accepts_nested_attributes_for :vouch_items, allow_destroy: true
  attr_accessible :vouch_items_attributes

  validates_presence_of :owner_id, :title

  before_create :set_defaults

  def set_defaults
    self.status  = "pending"
    self.title ||= "Favorite restaurants for a sunny company outing"
  end

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

      items << new_item
    end
    items
  end
end
