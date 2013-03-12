class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :vouch_item

  attr_accessible :vouch_item_id, :tag_id
end
