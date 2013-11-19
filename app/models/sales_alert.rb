class SalesAlert < ActiveRecord::Base
  attr_accessible :user_id, :email_sent
   
  belongs_to :user
  has_and_belongs_to_many :full_items_sales_alerts, :class_name => "FullItem", :join_table => 'full_items_sales_alerts'
end
