class Bedroom < ApplicationRecord
  self.primary_key = 'bedroom_id'
  has_many :reservations, foreign_key: 'bedroom_id'
  belongs_to :category_bedroom, foreign_key: 'category_bedroom_id', class_name: 'CategoryBedroom'
end
