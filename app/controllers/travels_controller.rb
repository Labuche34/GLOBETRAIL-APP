class TravelsController < ApplicationController
  def new
    @travel = Travel.new(params[:travel_id])
  end

  def create
    @travel = Travel.new(params[:travel_id])
    if @travel.save
      redirect_to travel_path(@travel)
    else
      puts "Wrong entries, your travel hasn't been create"
      render :new, status: :unprocessable_entity
  end

  private

  def travel_params
    params.require(:travel).permit(:country, :number_of_travellers, :budget, :departure_city)
  end
end
