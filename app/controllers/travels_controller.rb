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

  def edit
    @travel = Travel.find(params[:id])
  end

  def update
    @travel = Travel.find(params[:id])
    if @travel.update(travel_params)
      redirect_to travel_path(@travel)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @travel = Travel.find(params[:id])
    @travel.destroy
    redirect_to travels_path
  end

  private

  def travel_params
    params.require(:travel).permit(:country, :number_of_travellers, :budget, :trip_duration, :departure_city, :travellers_type)
  end
end
