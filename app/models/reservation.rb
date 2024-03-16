class Reservation < ApplicationRecord
  belongs_to :resident, foreign_key: 'resident_id', class_name: 'Resident'
  belongs_to :user, foreign_key: 'user_id', class_name: 'User'
  belongs_to :bedroom, foreign_key: 'bedroom_id', class_name: 'Bedroom'
  accepts_nested_attributes_for :resident
  belongs_to :pay
end
