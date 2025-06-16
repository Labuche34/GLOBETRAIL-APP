class StopsController < ApplicationController
  def create
    @stop = Stop.new(stop_params)
    @travel = Travel.find(params[:travel_id])
    @stop.travel = @travel
    @stop.save
    redirect_to travel_path(@travel)

  end

  def edit
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:id])
    @note = Note.new
    @picture = Picture.new
    @spending = Spending.new
  end

  def update
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:id])
    if @stop.update(stop_params)
      redirect_to travel_path(@travel)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stop = Stop.find(params[:id])
    @stop.destroy
    redirect_to travel_path(@stop.travel), status: :see_other
  end

  private

  def stop_params
    params.require(:stop).permit(:city)
  end
end
