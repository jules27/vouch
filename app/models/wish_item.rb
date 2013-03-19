class WishItem < ActiveRecord::Base
  belongs_to :wish_list
  belongs_to :business
  belongs_to :user # Friend who inspired

  # TODO: add taggings

  attr_accessible :wish_list_id, :business_id, :user_id

  validates_presence_of :wish_list_id, :business_id
  validate :no_duplicate_items_in_list

  private

  def no_duplicate_items_in_list
    if wish_list.wish_items.find_by_business_id(self.business_id).present?
      result = wish_list.wish_items.find_by_business_id(self.business_id)
      errors.add(:wish_list_id, "cannot contain duplicate items (#{self.business_id}).")
    end
  end
end
