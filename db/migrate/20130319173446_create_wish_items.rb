class CreateWishItems < ActiveRecord::Migration
  def change
    create_table :wish_items do |t|
      t.integer :wish_list_id, null: false
      t.integer :business_id, null: false
      t.integer :user_id

      t.timestamps
    end
  end
end
