class Business < ActiveRecord::Base
  include PgSearch

  belongs_to :business_type
  has_many   :vouch_items
  has_many   :wish_items

  attr_accessible :business_type_id, :name, :phone, :address_line_1, :address_line_2,
                  :city, :state, :zip, :neighborhood, :categories,
                  :yelp_id, :yelp_rating, :yelp_review_count,
                  :latitude, :longitude, :image_url

  serialize :categories
  attr_accessible :categories_raw

  validates_presence_of :business_type_id, :name
  validates :name, uniqueness: { scope: [:latitude, :longitude, :city],
                                 message: "A business with the same name and coordinates already exists." }

  pg_search_scope :category_search, against: [:categories],
    using:{tsearch: {dictionary: "english"}}

  # For editing in active admin
  def categories_raw
    self.categories.join("|") if categories.present?# and categories.class != String
  end

  def categories_raw=(values)
    self.categories = []
    self.categories = values.split("|")
  end

  def categories_formatted
    c = Array.new
    categories.each_with_index do |category, index|
      c << category if index % 2 == 0
    end
    c.join(", ")
  end

  def self.search_by_category(category, city)
    category_search(category).where(city: city.name)
  end
end