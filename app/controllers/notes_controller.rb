class NotesController < ApplicationController
  def index
    @notes = Note.all
  end

  def show
    @travel = Travel.find(params[:travel_id])
    @note = Note.find(params[:id])
    @stop = Stop.new
  end

  def new
    # stop + notes = bien rattaché ensemble et non dans un autre stop
    @stop = Stop.find(params[:stop_id])
    @note = @stop.notes.new
  end

  def create
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @note = @stop.notes.new(note_params)
    @note.save
    redirect_to travel_path(@stop.travel)
  end

  def edit
    @travel = Travel.find(params[:travel_id])
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    if @note.update(note_params)
      redirect_to travel_path(@note.stop.travel)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note = Note.find(params[:id])
    stop = @note.stop
    @note.destroy
    redirect_to travel_path(stop.travel)
  end

  private

  def note_params
    params.require(:note).permit(:content)
  end
end
