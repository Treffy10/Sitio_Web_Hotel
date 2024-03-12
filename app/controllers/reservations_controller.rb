class ReservationsController < ApplicationController
  def index
    @bedrooms = CategoryBedroom.all
    @pay = Pay.all
  end

  def new
    @reservation = Reservation.new
    @category_bedroom = CategoryBedroom.find(params[:category_bedroom_id])
    @pay = Pay.all
    @reservation.build_resident
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @resident = Resident.new(resident_params)
    @recepcionist = Receptionist.new(:null)

    category_bedroom = CategoryBedroom.find(params[:category_bedroom_id])
    available_bedrooms = category_bedroom.bedrooms.where(availability: 0)
    random_available_bedroom = available_bedrooms.order("RANDOM()").first

    if random_available_bedroom.present?
      @reservation.bedroom = random_available_bedroom
      @reservation.resident = @resident
      @reservation.recepcionist = @recepcionist
      # Salva la reservacion y actualiza "availability" de bedroom
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
    params.require(:reservation).permit(:recepcionist_id, :resident_id, :bedroom_id, :arrivalDate, :departureDate, :state)
  end

  def resident_params
    params.require(:resident).permit(:name, :lastnamePaternal, :lastnameMaternal, :dni, :phone, :location, :birthday, :nationality, :email)
  end
end
