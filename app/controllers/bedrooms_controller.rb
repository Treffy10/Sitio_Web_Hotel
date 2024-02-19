class BedroomsController < ApplicationController
  def index
    @bedrooms = CategoryBedroom.all
  end

  def show
    @bedroom = CategoryBedroom.find(params[:id])
  end
end
