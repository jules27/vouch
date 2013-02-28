class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :token, :string
    add_column :users, :gender, :string
    add_column :users, :location, :string
    add_column :users, :image, :string
  end
end
