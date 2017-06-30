class NotesController < ApplicationController

  before_action :solve_note, only: [:show, :update, :destroy]

  def index
    notes = Note.all
    render json: notes, status: :ok
  end

  def create
    note = Note.new(note_params)
    note.user = current_user
    if note.save
      response = {
        message: 'Note was successfully created in the database!',
        note: note,
        status: :ok
      }
    else
      response = {
        error: note.errors.to_a.join(','),
        status: :unprocesable_entity
      }
    end
    render json: response, status: response[:status]
  end

  def show
    render json: @note, status: :ok
  end

  def update
    if @note.update_attributes(note_params)
      response = {
        message: 'Note was successfully updated in the database!',
        note: @note,
        status: :ok
      }
    else
      response = {
        error: @note.errors.to_a.join(','),
        status: :unprocesable_entity
      }
    end
    render json: response, status: response[:status]
  end

  def destroy
    if @note.destroy
      response = {
        message: 'The note was successfully deleted!',
        status: :ok
      }
    else
      response = {
        error: @note.errors.to_a.join(','),
        status: :unprocesable_entity
      }
    end
    render json: response, status: response[:status]
  end

  private

  def solve_note
    begin
      id = params[:id]
      @note = Note.find id
    rescue ActiveRecord::RecordNotFound
      render json: {error: "Note not found with id #{id}"}, status: :not_found
    end
  end

  def note_params
    params.require(:note).permit(:title, :content, :shared)
  end

end
