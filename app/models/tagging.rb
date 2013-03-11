class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :vouch_item
end
