# Siempre al pasar valores de otros controller a otro controller para poder usar su valor se usa params

class ReservationsController < ApplicationController
  def index
    # Convertir fechas a tipos Date
    @fecha_entrada = Date.parse(params[:fecha_entrada])
    @fecha_salida = Date.parse(params[:fecha_salida])

    # Calcular la duración de la estadía en noches
    @duracion_estadia = (@fecha_salida - @fecha_entrada).to_i

    if @fecha_entrada.present? && @fecha_salida.present?
      @overlapping_reservations = find_overlapping_reservations(@fecha_entrada, @fecha_salida)
      @non_overlapping_reservations = find_non_overlapping_reservations(@fecha_entrada, @fecha_salida)

      # Obtener todas las categorías con al  menos una habitación asignada y disponibilidad establecida en 1
      category_bedrooms = CategoryBedroom.joins(:bedrooms).where(bedrooms: { availability: 1 || 0 }).distinct

      if @overlapping_reservations.any?
        if @non_overlapping_reservations.any? || category_bedrooms.any?
          # Obtener las habitaciones de las reservas que no se superponen en fechas con la nueva futura reserva
          non_overlapping_bedrooms = @non_overlapping_reservations.flat_map(&:bedroom)
          # Obtener las categorías de las habitaciones de las reservas no superpuestas
          categories_from_reservations = non_overlapping_bedrooms.map(&:category_bedroom)

          #Combinar categorías de habitaciones de las reservas no superpuestas con las categorías existentes
          @available_categories = (category_bedrooms + categories_from_reservations).uniq
        else
          # Este caso serio extremo, ya que no habria ninguna habitacion disponible para cada categoria en esas fechas
          flash[:alert] = "No hay habitacion disponible para estas fechas :(, porfavor escoja otras" # Esto falta implementar con boostrap
          redirect_to "/"
        end
      else
        # Obtener las habitaciones de las reservas que no se superponen en fechas con la nueva futura reserva
        non_overlapping_bedrooms = @non_overlapping_reservations.flat_map(&:bedroom)
        # Obtener las categorías de las habitaciones de las reservas no superpuestas
        categories_from_reservations = non_overlapping_bedrooms.map(&:category_bedroom)

        #Combinar categorías de habitaciones de las reservas no superpuestas con las categorías existentes
        @available_categories = (category_bedrooms + categories_from_reservations).uniq
      end
    else
      flash[:alert] = "No se selecciono las fechas" # Esto falta implementar con boostrap
        redirect_to "/"
    end
  end

  def new
    # Obtener parámetros y convertir fechas
    puts "Parámetros recibidos: #{params.inspect}" # <-- Se obtendran los objetos params y se convertiran a texto para mostrarse por consola
    # Esto ayuda a vizualizar los parametros que se estan pasando en la solicitud HTTP

    # Convertir fechas a tipos Date
    @fecha_entrada = Date.parse(params[:fecha_entrada])
    @fecha_salida = Date.parse(params[:fecha_salida])

    # Calcular la duración de la estadía en noches
    @duracion_estadia = (@fecha_salida - @fecha_entrada).to_i

    if @fecha_entrada.present? && @fecha_salida.present?
      # Crear nueva reserva y obtener la categoría escogida
      @reservation = Reservation.new
      @category_bedroom = CategoryBedroom.find(params[:category_bedroom_id])

      # Llamamos a las reservas superpuestas
      @overlapping_reservations = find_overlapping_reservations(@fecha_entrada, @fecha_salida)

      # Primero obtenego las categorias de las reservas que se superponen existentes
      existing_categories = @overlapping_reservations.all.map { |reservation| reservation.bedroom.category_bedroom }
      @existing_categories = existing_categories.uniq  # El método uniq en Ruby se utiliza para eliminar duplicados de una lista.

      # Si la categoría de habitación está en la lista de categorías existentes
      if @existing_categories.include?(@category_bedroom)
        # Obtengo las bedrooms de las existing_categories que no estan reservadas o lo estan pero que no se superponen en fechas con la nueva reserva
        available_bedrooms = Bedroom.joins(:category_bedroom)
                              .where(category_bedrooms: { category_bedroom_id: @existing_categories.map(&:category_bedroom_id) })
                              .where.not(bedroom_id: @overlapping_reservations.map(&:bedroom_id))
        # Filtrar las habitaciones disponibles
        # available_bedrooms = filter_available_bedrooms(@overlapping_reservations, @category_bedroom)

        if available_bedrooms.empty?
          flash[:alert] = "No hay habitacion disponible para estas fechas :(, porfavor escoja otras" # Esto falta implementar con boostrap
          redirect_to reservas_path  # Aqui falta crear una ruta para estos casos
        else
          # Seleccionar una habitación aleatoriamente
          @bedroom_id = available_bedrooms.sample&.bedroom_id
        end
      else
        bedroom = @category_bedroom.bedrooms.sample
        @bedroom_id = bedroom.bedroom_id
      end

      # Obtener información adicional
      category_price = CategoryPrice.find(params[:category_price_id])
      @calculated_price = category_price.calculated_price(@duracion_estadia)
      @nights = params[:noches]
      @ocupacion = params[:ocupacion]

      # Construir un nuevo residente asociado a la reserva
      @reservation.build_resident
    else
      flash[:alert] = "No se selecciono las fechas" # Esto falta implementar con boostrap
      redirect_to "/"
    end
  end

  # Método para encontrar reservas que se superponen
  def find_overlapping_reservations(start_date, end_date)
    Reservation.where("arrivalDate < ? AND departureDate > ?", end_date, start_date)
  end

  # Método para encontrar reservas que no se superponen
  def find_non_overlapping_reservations(start_date, end_date)
  Reservation.where.not("arrivalDate < ? AND departureDate > ?", end_date, start_date)
  end

  # Método para filtrar habitaciones disponibles
  # def filter_available_bedrooms(reservations, category_bedroom)
  #  reserved_bedroom_ids = reservations.pluck(:bedroom_id).uniq
  #  category_bedroom.bedrooms.where.not(category_bedroom_id: reserved_bedroom_ids)
  #end

  def create
    @category_bedroom = CategoryBedroom.find_by(category_bedroom_id: params[:category_bedroom_id])

    if @category_bedroom.nil?
      redirect_to new_reservation_path, alert: 'La categoría de habitación no existe'
      return
    end

    @reservation = Reservation.new(reservation_params)
    @user = User.find(1) # Se usará el user "fantasma" para estas reservas webs
    @pay = Pay.find(1)  # Se le asigna el pago por visa como determinado
    @reservation.state = 0 # Establecer el estado como 0 (por pagar)
    @reservation.arrivalDate = params[:fecha_entrada]
    @reservation.departureDate = params[:fecha_salida]
    @reservation.full_payment = params[:pago_total]
    # Ensure valid integer ID
    bedroom_id = params[:bedroom_available].to_i

    # Verifique la identificación y busque el registro del dormitorio
    bedroom = Bedroom.find_by(bedroom_id: bedroom_id)

    # Esta condicional no se cumpliria casi nunca pero buee
    if bedroom.nil? || bedroom.category_bedroom_id != @category_bedroom.category_bedroom_id
      redirect_to new_reservation_path, alert: 'La categoria o habitacion no existen.'
      return
    end

    # Si la habitación está disponible y pertenece a la categoría correcta, asignarla a la reserva
    @reservation.user = @user
    @reservation.bedroom = bedroom
    @reservation.pay = @pay # Aqui se le asigna el metodo de pago predeterminado

    if @reservation.save
      redirect_to pagos_path(reservation_id: @reservation.reservation_id), notice: 'La reserva se creó exitosamente.'
    else
      puts @reservation.errors.full_messages
      # render :new <-- Aqui se tendria que enviar a una pagina en especifico como una view de emergencia para estos casos especiales
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:user_id, :bedroom_id, :pay_id , :full_payment , :arrivalDate, :departureDate, :state,
    resident_attributes: [:name, :lastnamePaternal, :lastnameMaternal, :dni, :phone, :location, :birthday, :nationality, :email])
  end
end
