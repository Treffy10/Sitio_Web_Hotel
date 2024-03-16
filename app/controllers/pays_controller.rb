class PaysController < ApplicationController
  def index
    @payment_method = Pay.(all)

  end
end
