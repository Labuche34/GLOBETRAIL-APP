class PagesController < ApplicationController
  def home
    @travel = Travel.all.count
    @stop = Stop.all.count
    # @day = Travel.all.sum do |travel|
    #   (travel.return_date - travel.departure_date).to_i + 1
    # end
  end
end
