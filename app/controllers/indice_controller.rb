class IndiceController < ApplicationController
  def index
    # Obtener todas las categorías de habitaciones
    @category_bedrooms = CategoryBedroom.all

    # Obtener reservas existentes que se superponen con el lapso de tiempo proporcionado
    existing_reservations = Reservation.where('(arrivalDate <= ? AND departureDate >= ?) OR (arrivalDate >= ? AND departureDate <= ?) OR (arrivalDate <= ? AND departureDate >= ?)',
                                                params[:fecha_salida], params[:fecha_entrada],
                                                params[:fecha_entrada], params[:fecha_salida],
                                                params[:fecha_entrada], params[:fecha_salida])

    # Obtener las ID de las habitaciones reservadas
    reserved_bedroom_ids = existing_reservations.pluck(:bedroom_id)

    # Filtrar las categorías de habitaciones disponibles
    @available_category_bedrooms = @category_bedrooms.reject do |category_bedroom|
      reserved_bedroom_ids.include?(category_bedroom.id)
    end
  end
end
