class TravelsController < ApplicationController
  before_action :set_travel, only: %i[show]

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
    set_travel
    @stop = Stop.new
  end

  private

  def travel_params
    params.require(:travel).permit(:country, :number_of_travellers, :budget, :trip_duration, :departure_city, :travellers_type)
  end

  def set_travel
    @travel = Travel.find(params[:id])
  end
end
