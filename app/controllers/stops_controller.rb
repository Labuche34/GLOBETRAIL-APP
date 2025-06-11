class StopsController < ApplicationController
  before_action :set_travel, only: %i[new create]
  def create
    @stop = Stop.new(stop_params)
    @stop.travel = @travel
    @stop.save
    redirect_to travel_path(@travel)
  end

  private

  def set_travel
    @travel = Travel.find(params[:travel_id])
  end

  def review_params
    params.require(:stop).permit(:content)
  end
end
