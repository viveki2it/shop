class CategoriesFullItem < ActiveRecord::Base
  belongs_to :full_item
  belongs_to :category
end
