class AddDisplayNameToCities < ActiveRecord::Migration
  def change
    add_column :cities, :display_name, :string, after: :name
  end
end
