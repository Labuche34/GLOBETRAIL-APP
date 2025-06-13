class PagesController < ApplicationController
  def home
    @travel = Travel.all.count
    @stop = Stop.count
    #raise
    #@travelling_days = Travel.last.return_date - Travel.last.departure_date
  end
end
