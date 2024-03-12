class Bedroom < ApplicationRecord
  has_many :reservations, foreign_key: 'bedroom_id'
  belongs_to :category_bedrooms, foreign_key: 'category_bedroom_id', class_name: 'CategoryBedroom'
end
