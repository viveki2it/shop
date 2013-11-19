class RetailerCategory < ActiveRecord::Base
  belongs_to :retailer
  belongs_to :master_category

  def to_s
    self.name
  end
end
