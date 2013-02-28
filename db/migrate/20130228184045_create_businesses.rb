class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.references :business_type, null: false
      t.string  :name, null: false
      t.string  :phone
      t.string  :address_line_1
      t.string  :address_line_2
      t.string  :city
      t.string  :state
      t.string  :zip
      t.string  :neighborhood
      t.text    :categories
      t.string  :yelp_id
      t.integer :yelp_rating
      t.integer :yelp_review_count
      t.string  :image_url
      t.float   :latitude
      t.float   :longitude

      t.timestamps
    end
  end
end
