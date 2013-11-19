class Interaction < ActiveRecord::Base
   attr_accessible :user_identifier, :event_type, :count, :user_agent
   belongs_to :target, :polymorphic => true
end
