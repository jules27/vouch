class VouchItem < ActiveRecord::Base
  belongs_to :vouch_list
  has_one    :business
  has_many   :taggings
  has_many   :tags, through: :taggings

  attr_accessible :vouch_list_id, :business_id, :description

  validates_presence_of :vouch_list_id, :business_id

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end
end