class FullItemsSalesAlert < ActiveRecord::Base
   attr_accessible :full_item_id, :sales_alert_id
   
   belongs_to :full_item
   belongs_to :sales_alert
end
