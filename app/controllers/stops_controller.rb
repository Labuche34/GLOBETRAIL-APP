class StopsController < ApplicationController
  def create
    @stop = Stop.new(stop_params)
    @travel = Travel.find(params[:travel_id])
    @stop.travel = @travel
    @stop.save
    redirect_to travel_path(@travel)
  end

  private

  def stop_params
    params.require(:stop).permit(:address)
  end
end
