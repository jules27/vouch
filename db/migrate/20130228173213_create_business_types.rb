class CreateBusinessTypes < ActiveRecord::Migration
  def change
    create_table :business_types do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
