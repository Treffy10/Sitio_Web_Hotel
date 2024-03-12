class Receptionist < ApplicationRecord
  has_many :reservations, foreign_key: 'recepcionist_id'
end
