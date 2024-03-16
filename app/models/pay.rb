class Pay < ApplicationRecord
  self.primary_key = 'pay_id'
  has_many :reservations
end
