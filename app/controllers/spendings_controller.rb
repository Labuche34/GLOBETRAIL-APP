class SpendingsController < ApplicationController
  def index
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @spendings = Spending.all
    # sera sur la page visualisation de figma avec spendings et notes
  end

  def new
    @spending = Spending.new
  end

  def create
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @spending = Spending.new(spending_params)
    @stop.travel = @travel
    @spending.stop = @stop
    @spending.save
    redirect_to travel_stop_pictures_path(@travel, @stop)
  end

  def edit
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @spending = Spending.find(params[:id])
    # sera sur la page visualisation de figma avec spendings et notes
  end

  def update
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @spending = Spending.find(params[:id])
    if @spending.update(spending_params)
      redirect_to stop_path(@stop)
    else
      render :edit, status: :unprocessable_entity
    end
    # sera sur la page visualisation de figma avec spendings et notes
  end

  def destroy
    @spending = Spending.find(params[:id])
    @spending.destroy
    redirect_to stop_path(@spending.stop), status: :see_other
    # sera sur la page visualisation de figma avec spendings et notes
  end

  private

  def spending_params
    params.require(:spending).permit(:category, :amount, :currency)
  end
end
