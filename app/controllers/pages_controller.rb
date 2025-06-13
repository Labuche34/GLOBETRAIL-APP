class PagesController < ApplicationController
  def home
    @travels = Travel.all.count
    @stops = Stop.count
    @days = Travel.all.sum do |travel|
      (travel.return_date - travel.departure_date).to_i + 1
    end
  end
end
