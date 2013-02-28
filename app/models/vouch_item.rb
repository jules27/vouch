class VouchItem < ActiveRecord::Base
  belongs_to :vouch_list
  has_one    :business

  attr_accessible :vouch_list_id, :business_id, :description

  validates_presence_of :vouch_list_id, :business_id
end