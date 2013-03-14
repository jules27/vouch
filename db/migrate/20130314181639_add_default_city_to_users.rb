class AddDefaultCityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :city_id, :integer, after: :image
  end
end
