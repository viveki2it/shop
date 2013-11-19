class AlertedFullItem < ActiveRecord::Base
  attr_accessible :user_id, :full_item_id
  
  belongs_to :full_item
  belongs_to :user
end