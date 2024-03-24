class PaysController < ApplicationController
  def index
    # Obtenemos todos los objetos Pay
    @payment_method = Pay.all
    # Obtenemos el id de la reserva nueva
    @reservation_id = params[:reservation_id]
  end

  def change
    # Obtenemos el pay_id escogido
    pay_id = params[:pay_id]
    # Obtenemos el objeto de ese id
    @change_pay = Pay.find(pay_id)
    # De nuevo obtenemos el id de la reserva
    @reservation_id = params[:reservation_id]

    # Ahora procederemos a cambiar el campo pay_id de esta reserva por el pay_id escogido
    reservation = Reservation.find(@reservation_id)
    reservation.update(pay_id: @change_pay.pay_id)

    if reservation.save
      reservation.update(state: 1) # La reserva ha sido pagada
      today = Date.today
      if reservation.arrivalDate == today
        # Si es el día de llegada concuerda con el de hoy, entonces la habitación ya será ocupada
        reservation.bedroom.update(availability: 0)
      end
      redirect_to root_path, notice: 'Reserva realizada con éxito'
    else
      redirect_to root_path, alert: 'Error al realizar la reserva'
    end
  end
end
