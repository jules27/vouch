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
    self.save
  end
end
