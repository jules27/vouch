class CreateWishLists < ActiveRecord::Migration
  def change
    create_table :wish_lists do |t|
      t.integer :user_id, null: false
      t.integer :city_id, null: false

      t.timestamps
    end
  end
end
