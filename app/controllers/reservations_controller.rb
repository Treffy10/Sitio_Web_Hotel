class ReservationsController < ApplicationController
  def index
    @fecha_entrada = params[:fecha_entrada]
    @fecha_salida = params[:fecha_salida]

    # Convertir las fechas de cadena a objetos de fecha
    fecha_entrada = Date.parse(@fecha_entrada)
    fecha_salida = Date.parse(@fecha_salida)

    # Calcular la duración de la estadía en noches
    @duracion_estadia = (fecha_salida - fecha_entrada).to_i

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

  def new
    @fecha_entrada = params[:fecha_entrada]
    @fecha_salida = params[:fecha_salida]

    fecha_entrada = Date.parse(@fecha_entrada)
    fecha_salida = Date.parse(@fecha_salida)

    @duracion_estadia = (fecha_salida - fecha_entrada).to_i

    @reservation = Reservation.new
    @category_bedroom = CategoryBedroom.find(params[:category_bedroom_id])
    @nights = params[:noches]
    category_price = CategoryPrice.find(params[:category_price_id])  # Suponiendo que pasas el ID del precio de categoría
    @calculated_price = category_price.calculated_price(@duracion_estadia)
    @ocupacion = params[:ocupacion]
    @reservation.build_resident # Construye un residente asociado a la reserva
  end

  def create
    @category_bedroom = CategoryBedroom.find_by(category_bedroom_id: params[:category_bedroom_id])

    if @category_bedroom.nil?
      redirect_to new_reservation_path, alert: 'La categoría de habitación no existe'
    return
    end

    @reservation = Reservation.new(reservation_params)
    @user = User.find(1) # Se usará el user "fantasma" para estas reservas webs
    @reservation.state = 0 # Establecer el estado como 0 (por pagar)
    @reservation.arrivalDate = params[:fecha_entrada]
    @reservation.departureDate = params[:fecha_salida]
    @reservation.full_payment = params[:pago_total]
    @pay = Pay.find(2)

    available_bedrooms = @category_bedroom.bedrooms.where(avaibility: 0)
    random_available_bedroom = available_bedrooms.order("RANDOM()").first

    if random_available_bedroom.present?
      @reservation.bedroom = random_available_bedroom
      @reservation.user = @user # Asignar el usuario "fantasma" a la reserva
      # Asignar un valor nulo a pay_id
      @reservation.pay = @pay

    if @reservation.save
      random_available_bedroom.update(avaibility: 1)
      # Asignar el pay_id después de crear la reservación
      redirect_to pagos_path(reservation_id: @reservation.id), notice: 'La reserva se creó exitosamente.'
    else
      # Agrega esta línea:
      puts @reservation.errors.full_messages
      render :new
    end
    else
      redirect_to new_reservation_path, alert: 'No hay habitaciones disponibles en esta categoría.'
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:user_id, :bedroom_id, :pay_id , :full_payment , :arrivalDate, :departureDate, :state,
    resident_attributes: [:name, :lastnamePaternal, :lastnameMaternal, :dni, :phone, :location, :birthday, :nationality, :email])
  end
end
