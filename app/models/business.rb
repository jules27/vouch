class Business < ActiveRecord::Base
  belongs_to :business_type

  attr_accessible :business_type_id, :name, :phone, :address_line_1, :address_line_2,
                  :city, :state, :zip, :neighborhood, :categories,
                  :yelp_id, :yelp_rating, :yelp_review_count,
                  :latitude, :longitude, :image_url

  serialize :categories
  attr_accessible :categories_raw

  validates_presence_of :business_type_id, :name
  validates :name, uniqueness: { scope: [:latitude, :longitude],
                                 message: "A business with the same name and coordinates already exists." }

  # For editing in active admin
  def categories_raw
    self.categories.join("|") if self.categories.present?
  end

  def categories_raw=(values)
    self.categories = []
    self.categories = values.split("|")
  end
end