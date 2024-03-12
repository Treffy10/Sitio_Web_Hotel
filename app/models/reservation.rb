class Reservation < ApplicationRecord
  belongs_to :resident, foreign_key: 'resident_id', class_name: 'Resident'
  belongs_to :receptionists, foreign_key: 'recepcionist_id', class_name: 'Receptionist'
  belongs_to :bedrooms, foreign_key: 'bedroom_id', class_name: 'Bedroom'
  accepts_nested_attributes_for :resident
end
