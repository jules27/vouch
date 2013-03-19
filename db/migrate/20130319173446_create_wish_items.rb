class CreateWishItems < ActiveRecord::Migration
  def change
    create_table :wish_items do |t|
      t.integer :list_id, null: false
      t.integer :business_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
