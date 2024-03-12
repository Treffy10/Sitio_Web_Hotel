class Resident < ApplicationRecord
  has_many :reservations, foreign_key: 'resident_id'
end
