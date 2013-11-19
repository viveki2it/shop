class MasterCategory < ActiveRecord::Base
  # legacy generic category mappings
  has_many :categories
	has_many :items, :through => :categories

  # new retailer specific category mappings to full items
  has_many :retailer_categories
  has_many :full_items, :through => :retailer_categories

	def male_only_name
		self.male_name || self.name
	end

  def to_s
    self.name
  end
end
