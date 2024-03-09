class Resident < ApplicationRecord
  has_one :reservation
end
