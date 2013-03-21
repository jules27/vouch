class WishItem < ActiveRecord::Base
  belongs_to :wish_list
  belongs_to :business
  belongs_to :user # Friend who inspired
  has_many   :wish_taggings, dependent: :destroy
  has_many   :tags, through: :wish_taggings

  attr_accessible :wish_list_id, :business_id, :user_id

  validates_presence_of :wish_list_id, :business_id
  validate :no_duplicate_items_in_list
  validate :no_duplicate_items_in_vouch_list

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

  private

  def no_duplicate_items_in_list
    if wish_list.wish_items.find_by_business_id(self.business_id).present?
      errors.add(:wish_list_id, "already contains item \"#{self.business.name}\".")
    end
  end

  # Similar to the duplicate items check for wish list, except look for
  # duplicates in the user's primary vouch list.
  def no_duplicate_items_in_vouch_list
    vouch_list = wish_list.user.vouch_list_primary
    if vouch_list.vouch_items.find_by_business_id(self.business_id).present?
      errors.add(:vouch_list, "already contains item \"#{self.business.name}\".")
    end
  end
end
