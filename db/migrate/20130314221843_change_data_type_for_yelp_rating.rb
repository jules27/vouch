class ChangeDataTypeForYelpRating < ActiveRecord::Migration
  def up
    change_table :businesses do |t|
      t.change :yelp_rating, :float
    end
  end

  def down
    change_table :businesses do |t|
      t.change :yelp_rating, :integer
    end
  end
end
