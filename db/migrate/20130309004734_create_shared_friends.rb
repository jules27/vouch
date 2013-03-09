class CreateSharedFriends < ActiveRecord::Migration
  def change
    create_table :shared_friends do |t|
      t.references :vouch_list, null: false
      t.references :user
      t.string     :email
      t.string     :name
      t.string     :facebook_id

      t.timestamps
    end
  end
end
