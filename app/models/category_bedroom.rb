class CategoryBedroom < ApplicationRecord
  has_many :bedrooms, foreign_key: 'category_bedroom_id'
end
