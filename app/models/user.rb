class User < ApplicationRecord
  has_many :Reservation, foreign_key: 'user_id'
end
