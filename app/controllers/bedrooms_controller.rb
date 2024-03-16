class BedroomsController < ApplicationController
  def index
    @bedrooms = CategoryBedroom.all
  end

  def show
    @category_bedroom = CategoryBedroom.find(params[:id])
  end
end
