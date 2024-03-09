class ReservationsController < ApplicationController
  def index
    @bedrooms = CategoryBedroom.all
    @pay = Pay.all
  end

  def new
    @reservation = Reservation.new
    @categoryBedroom = CategoryBedroom.find(params[:categoryBedroomID])
    @pay = Pay.all
    @resident = Resident.new
    @reservation.build_resident  # Crea un nuevo residente asociado a la reserva
  end
end
