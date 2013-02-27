class CreateVouchLists < ActiveRecord::Migration
  def change
    create_table :vouch_lists do |t|
      t.integer :owner_id, null: false
      t.string  :title, null: false
      t.text    :description
      t.string  :status

      t.timestamps
    end
  end
end
