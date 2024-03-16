class CategoryPrice < ApplicationRecord
  self.primary_key = 'category_price_id'
  belongs_to :category_bedroom, foreign_key: 'category_bedroom_id'

  def calculated_price(duration_estadia)
    price_night = category_bedroom.priceNight
    discount_web = descuento_web
    price_night * discount_web * duration_estadia
  end

end
