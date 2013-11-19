class RecordedLike < ActiveRecord::Base
  belongs_to :user
  belongs_to :full_item
end
