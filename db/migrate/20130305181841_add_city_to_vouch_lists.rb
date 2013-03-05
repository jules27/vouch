class AddCityToVouchLists < ActiveRecord::Migration
  def change
    add_column :vouch_lists, :city_id, :integer, after: :owner_id
  end
end
