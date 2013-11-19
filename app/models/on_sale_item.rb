class OnSaleItem < ActiveRecord::Base
  attr_accessible :full_item
  belongs_to :full_item
end
