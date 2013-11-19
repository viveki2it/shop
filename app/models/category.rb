class Category < ActiveRecord::Base
	belongs_to :master_category
	has_many :items_categories
	has_many :items, :through => :items_categories

  def to_s
    self.name
  end
end
