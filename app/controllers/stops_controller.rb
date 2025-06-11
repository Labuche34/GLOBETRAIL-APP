class StopsController < ApplicationController
  def create
    @stop = Stop.new(stop_params)
    @travel = Travel.find(params[:travel_id])
    @stop.travel = @travel
    @stop.save
    redirect_to travel_path(@travel)
  end

  def edit
    @stop = Stop.find(params[:id])
  end

  def update
    @stop = Stop.find(params[:id])
    if @stop.update(stop_params)
      redirect_to stop_path(@stop)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stop = Stop.find(params[:id])
    @stop.destroy
    redirect_to stops_path, status: :see_other
  end

  private

  def set_travel
    @travel = Travel.find(params[:travel_id])
  end

  def stop_params
    params.require(:stop).permit(:city)
  end
end
