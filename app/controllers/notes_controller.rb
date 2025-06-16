class NotesController < ApplicationController
  def index
    @notes = Note.all
  end

  def new
    @note = Note.new
  end

  def create
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @note = Note.new(note_params)
    @stop.travel = @travel
    @note.stop = @stop
    @note.save
    redirect_to travel_stop_pictures_path(@travel, @stop)
  end

  def show
    @travel = Travel.find(params[:travel_id])
    @note = Note.find(params[:id])
    @stop = Stop.new
  end

  def edit
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @note = Note.find(params[:id])
  end

  def update
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @note = Note.find(params[:note][:note_id])
    if @note.update!(note_params)
      # redirect_to note_path(@note)
      redirect_to travel_stop_pictures_path(@travel, @stop)
    else
      render template: 'pictures/index', status: :unprocessable_entity
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    redirect_to stop_path(@note.stop), status: :see_other
  end

  private

  def note_params
    params.require(:note).permit(:content)
  end
end
