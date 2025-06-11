class TravelsController < ApplicationController

  def index
    @travels = Travel.all
  end

  def new
    @travel = Travel.new
  end

  def create
    @travel = Travel.new(travel_params)
    @travel.user = current_user
    if @travel.save
      redirect_to travel_path(@travel)
    else
      puts "Wrong entries, your travel hasn't been created"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @travel = Travel.new
    @travels = Travel.all
  end

  private

  def travel_params
    params.require(:travel).permit(:country, :number_of_travellers, :budget, :trip_duration, :departure_city, :travellers_type)
  end
end
