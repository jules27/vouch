class Business < ActiveRecord::Base
  belongs_to :business_type

  attr_accessible :business_type_id, :name, :phone, :address_line_1, :address_line_2,
                  :city, :state, :zip, :neighborhood, :categories,
                  :yelp_id, :yelp_rating, :yelp_review_count,
                  :latitude, :longitude
  serialize :categories

  validates_presence_of :business_type_id, :name
end