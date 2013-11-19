class RetailerColour < ActiveRecord::Base
  belongs_to :retailer
  belongs_to :master_colour
end
