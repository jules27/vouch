class WishTagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :wish_item

  attr_accessible :wish_item_id, :tag_id
end
