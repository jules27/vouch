class Business < ActiveRecord::Base
  belongs_to :business_type
  has_many   :vouch_items

  attr_accessible :business_type_id, :name, :phone, :address_line_1, :address_line_2,
                  :city, :state, :zip, :neighborhood, :categories,
                  :yelp_id, :yelp_rating, :yelp_review_count,
                  :latitude, :longitude, :image_url

  serialize :categories
  attr_accessible :categories_raw

  validates_presence_of :business_type_id, :name
  validates :name, uniqueness: { scope: [:latitude, :longitude, :city],
                                 message: "A business with the same name and coordinates already exists." }

  after_create :get_data_from_yelp

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

  private

  def get_data_from_yelp
    return if yelp_id.present?

    type = BusinessType.find(business_type_id)
    results = YelpHelper.search_for_business(type.name, name, city, state)
    add_to_database(results, type)
  end

  def add_to_database(results, type)
    results.each do |restaurant|
      existing_restaurant = Business.find_by_name_and_latitude_and_longitude(
                                        restaurant[:name],
                                        restaurant[:latitude],
                                        restaurant[:longitude])
      if existing_restaurant.present?
        puts "Restaurant exists in database: #{restaurant[:name]}"
        existing_restaurant.update_attributes(restaurant.except(:distance, :yelp_url))
      else
        puts "Creating a new restaurant..."
        restaurant[:business_type_id] = type.id
        b = Business.create!(restaurant.except(:distance, :yelp_url))
        puts "     ...added restaurant! #{b.name} in #{b.city}"
      end
    end
  end
end