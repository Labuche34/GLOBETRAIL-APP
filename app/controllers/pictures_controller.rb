class PicturesController < ApplicationController
  def index
    @picture = Picture.all
    # sera sur la page visualisation de figma avec spendings et notes
  end

  def new
    @picture = Picture.new
  end

  def create
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @picture = Picture.new(picture_params)
    @stop.travel = @travel
    @picture.stop = @stop
    @picture.save
    redirect_to travel_stop_pictures_path(@travel, @stop)
  end

  def edit
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @picture = Picture.find(params[:id])
    # sera sur la page visualisation de figma avec spendings et notes
  end

  def update
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @picture = Picture.find(params[:id])
    if @picture.update(picture_params)
      redirect_to stop_path(@stop)
    else
      render :edit, status: :unprocessable_entity
    end
    # sera sur la page visualisation de figma avec spendings et notes
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    redirect_to stop_path(@picture.stop), status: :see_other
    # sera sur la page visualisation de figma avec spendings et notes
  end

  private

  def picture_params
    params.require(:picture).permit(:description)
  end
end
