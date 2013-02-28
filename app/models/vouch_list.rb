class VouchList < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  has_many   :vouch_items

  attr_accessible :owner_id, :title, :description, :status

  validates_presence_of :owner_id, :title

  before_create :set_defaults

  def set_defaults
    self.status = "saved"
    self.save
  end
end
