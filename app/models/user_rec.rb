class UserRec < ActiveRecord::Base
  belongs_to :full_item
  belongs_to :user
end
