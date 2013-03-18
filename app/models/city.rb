class City < ActiveRecord::Base
  attr_accessible :name, :display_name

  validates_presence_of :name
  validates_uniqueness_of :name

  def my_name
    display_name.present? ? display_name : name
  end

  def self.alphabetical
    self.find(:all, order: "name ASC")
  end
end
