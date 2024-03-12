class ReservationsController < ApplicationController
  def index
    @fecha_entrada = params[:fecha_entrada]
    @fecha_salida = params[:fecha_salida]

    # Obtener reservas existentes que se superponen con el lapso de tiempo proporcionado
    existing_reservations = Reservation.where('(arrivalDate <= ? AND departureDate >= ?) OR (arrivalDate >= ? AND departureDate <= ?) OR (arrivalDate <= ? AND departureDate >= ?)',
                                                @fecha_salida, @fecha_entrada,
                                                @fecha_entrada, @fecha_salida,
                                                @fecha_entrada, @fecha_salida)

    # Obtener todas las categorías de habitaciones
    @available_category_bedrooms = CategoryBedroom.includes(:bedrooms).where(bedrooms: { avaibility: 0 })

    # Filtrar las categorías de habitaciones disponibles basadas en las reservas existentes
    existing_category_bedroom_ids = existing_reservations.pluck(:bedroom_id).uniq
    @available_category_bedrooms = @available_category_bedrooms.where.not(id: existing_category_bedroom_ids)
  end

  def new
    @reservation = Reservation.new
    @category_bedroom = CategoryBedroom.find(params[:category_bedroom_id])
    @fecha_entrada = params[:fecha_entrada]
    @fecha_salida = params[:fecha_salida]
    @pay = Pay.all # <- Falta trabajar con esto
    @reservation.build_resident # Construye un residente asociado a la reserva
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @recepcionist = Receptionist.new # Crear una nueva instancia de Receptionist con valor nulo

    category_bedroom = CategoryBedroom.find(params[:category_bedroom_id])
    available_bedrooms = category_bedroom.bedrooms.where(availability: 0)
    random_available_bedroom = available_bedrooms.order("RANDOM()").first

    if random_available_bedroom.present?
      @reservation.bedroom = random_available_bedroom
      @reservation.recepcionist = @recepcionist # Asignar el recepcionista nulo a la reserva
      # Save the reservation
      if @reservation.save
        # Update the availability of the reserved bedroom
        random_available_bedroom.update(availability: 1)
        redirect_to @reservation, notice: 'La reserva se creó exitosamente.'
      else
        render :new
      end
    else
      redirect_to new_reservation_path, alert: 'No hay habitaciones disponibles en esta categoría.'
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:recepcionist_id, :bedroom_id, :arrivalDate, :departureDate, :state, resident_attributes: [:name, :lastnamePaternal, :lastnameMaternal, :dni, :phone, :location, :birthday, :nationality, :email])
  end
end
