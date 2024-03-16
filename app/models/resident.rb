class Resident < ApplicationRecord
  self.primary_key = 'resident_id'
  has_many :reservations, foreign_key: 'resident_id'
end
