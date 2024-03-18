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

    # Filtrar las categorías de habitaciones disponibles
    @available_category_bedrooms = @category_bedrooms.select do |category_bedroom|
      # Verificar si la categoría de habitación tiene al menos un Bedroom con availability en 0
      category_bedroom.bedrooms.any? { |bedroom| bedroom.avaibility == 0 }
    end

    # Obtener reservas existentes que se superponen con el lapso de tiempo proporcionado
    # existing_reservations = Reservation.where('(arrivalDate <= ? AND departureDate >= ?) OR (arrivalDate >= ? AND departureDate <= ?) OR (arrivalDate <= ? AND departureDate >= ?)',
                                              #  params[:fecha_salida], params[:fecha_entrada],
                                              #  params[:fecha_entrada], params[:fecha_salida],
                                              #  params[:fecha_entrada], params[:fecha_salida])

    # Obtener las ID de las habitaciones reservadas
    #reserved_bedroom_ids = existing_reservations.pluck(:bedroom_id)

    # Filtrar las categorías de habitaciones disponibles
    #@available_category_bedrooms = @category_bedrooms.reject do |category_bedroom|
    #  reserved_bedroom_ids.include?(category_bedroom.id)
    #end
  end

  def new
    # Obtener parámetros y convertir fechas
    puts "Parámetros recibidos: #{params.inspect}"

    @fecha_entrada = params[:fecha_entrada]
    @fecha_salida = params[:fecha_salida]

    fecha_entrada = Date.parse(@fecha_entrada)
    fecha_salida = Date.parse(@fecha_salida)

    # Calcular duración de la estadía
    @duracion_estadia = (fecha_salida - fecha_entrada).to_i

    # Crear nueva reserva y obtener categoría
    @reservation = Reservation.new
    @category_bedroom = CategoryBedroom.find(params[:category_bedroom_id])

    # Obtener reservas que se superponen
    existing_reservations = find_overlapping_reservations(fecha_entrada, fecha_salida)

    # Filtrar habitaciones disponibles
    available_bedrooms = filter_available_bedrooms(existing_reservations, @category_bedroom)

    # Seleccionar una habitación aleatoriamente
    @bedroom_id = available_bedrooms.sample&.bedroom_id

    # Si no hay habitaciones disponibles, mostrar mensaje
    if @bedroom_id.nil?
      flash[:alert] = "No hay habitaciones disponibles para la categoría seleccionada en las fechas indicadas."
      redirect_to new_reservation_path
      return
    end

    # Obtener información adicional
    @nights = params[:noches]
    category_price = CategoryPrice.find(params[:category_price_id])
    @calculated_price = category_price.calculated_price(@duracion_estadia)
    @ocupacion = params[:ocupacion]

    # Construir un nuevo residente asociado a la reserva
    @reservation.build_resident
  end

  # Método para encontrar reservas que se superponen
  def find_overlapping_reservations(arrival_date, departure_date)
    Reservation.where(
      "(arrivalDate >= ? AND arrivalDate < ?) OR (departureDate > ? AND departureDate <= ?) OR (arrivalDate <= ? AND departureDate >= ?)",
      arrival_date, departure_date, arrival_date, departure_date, arrival_date, departure_date)
  end

  # Método para filtrar habitaciones disponibles
  def filter_available_bedrooms(reservations, category_bedroom)
    reserved_bedroom_ids = reservations.pluck(:bedroom_id).uniq
    category_bedroom.bedrooms.where.not(category_bedroom_id: reserved_bedroom_ids)
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
    # Ensure valid integer ID
    bedroom_id = params[:bedroom_available].to_i

    # Verifique la identificación y busque el registro del dormitorio
    bedroom = Bedroom.find_by(bedroom_id: bedroom_id)

    if bedroom.nil? || bedroom.category_bedroom_id != @category_bedroom.category_bedroom_id
      redirect_to new_reservation_path, alert: 'La habitación disponible seleccionada no es válida para esta categoría.'
      return
    end

    # Si la habitación está disponible y pertenece a la categoría correcta, asignarla a la reserva
    @reservation.user = @user
    @reservation.bedroom = bedroom
    @reservation.build_pay

    if @reservation.save
      # Obtener la fecha actual
      today = Date.today

      # Si la fecha de entrada es hoy, actualizar la disponibilidad de la habitación
      if @reservation.arrivalDate == today
        bedroom.update(avaibility: 1)
      end
      redirect_to pagos_path(reservation_id: @reservation.reservation_id), notice: 'La reserva se creó exitosamente.'
    else
      puts @reservation.errors.full_messages
      render :new
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:user_id, :bedroom_id, :pay_id , :full_payment , :arrivalDate, :departureDate, :state,
    resident_attributes: [:name, :lastnamePaternal, :lastnameMaternal, :dni, :phone, :location, :birthday, :nationality, :email])
  end
end
