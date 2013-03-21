class VouchItem < ActiveRecord::Base
  belongs_to :vouch_list
  belongs_to :business
  has_many   :taggings, dependent: :destroy
  has_many   :tags, through: :taggings

  attr_accessible :vouch_list_id, :business_id, :description

  validates_presence_of :vouch_list_id, :business_id

  def tag_list
    return if tags.empty?

    "#" + tags.map(&:name).join(" #")
  end

  def tag_list=(names)
    # Don't process if a restaurant doesn't have a tag, ie. [""]
    return unless names.pop.present?

    self.tags = names.map do |n|
      Tag.where(name: n).first_or_create!
    end
  end
end