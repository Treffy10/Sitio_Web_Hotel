class IndiceController < ApplicationController
  def index
    # Obtener todas las categorías de habitaciones
    #@category_bedrooms = CategoryBedroom.all

    # Filtrar las categorías de habitaciones disponibles
    #@available_category_bedrooms = @category_bedrooms.select do |category_bedroom|
      # Verificar si la categoría de habitación tiene al menos un Bedroom con availability en 0
     # category_bedroom.bedrooms.any? { |bedroom| bedroom.avaibility == 0 }
    #end
  end
end
