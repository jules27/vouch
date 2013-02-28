class CreateVouchItems < ActiveRecord::Migration
  def change
    create_table :vouch_items do |t|
      t.references :vouch_list, null: false
      t.references :business, null: false
      t.text       :description

      t.timestamps
    end
  end
end
