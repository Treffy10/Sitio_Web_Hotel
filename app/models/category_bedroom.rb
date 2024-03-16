class CategoryBedroom < ApplicationRecord
  self.primary_key = 'category_bedroom_id'
  has_many :bedrooms, foreign_key: 'category_bedroom_id'         # Se declara aca que CategoryBedroom tendra muchas instancias de bedrooms y el
  has_many :category_prices, foreign_key: 'category_bedroom_id'  # nombre de la asociacion que se usara para las funcioneas es "bedrooms"
 end


# foreing_key esta por las puras xd, bueno no, asi se asegura que la clave foranea
# se llama de esa manera(en si ya esta asi en la tabla normal porque sigue la convencion)
