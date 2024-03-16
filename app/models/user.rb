class User < ApplicationRecord
  self.primary_key = 'user_id'
  has_many :reservations, foreign_key: 'user_id'
end
