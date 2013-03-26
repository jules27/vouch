class CreateWishTaggings < ActiveRecord::Migration
  def change
    create_table :wish_taggings do |t|
      t.belongs_to :tag
      t.belongs_to :wish_item

      t.timestamps
    end
    add_index :wish_taggings, :tag_id
    add_index :wish_taggings, :wish_item_id
  end
end
