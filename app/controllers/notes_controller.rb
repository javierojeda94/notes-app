class NotesController < ApplicationController

  before_action :solve_note, only: [:show, :update, :destroy]
  before_action :solve_searched_user, only: [:index, :show]

  def index
    if @searched_user
      if current_user == @searched_user
        notes = current_user.notes
      else
        notes = Note.shared.where(user: @searched_user)
      end
    else
      notes = Note.shared
    end
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
    begin
      @searched_user ||= @note.user
      if (current_user == @searched_user || @note.shared?) && @note.user == @searched_user
        response = JSON.parse @note.to_json
        response[:attachment_url] = @note.attachment.url
        render json: response, status: :ok
      else
        render status: :no_content
      end
    rescue ActiveRecord::RecordNotFound
      render json: {error: "User not found with id #{params[:user_id]}"}, status: :not_found
    end
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

  def solve_searched_user
    begin
      if params[:user_id]
        @searched_user = User.find params[:user_id]
      end
    rescue ActiveRecord::RecordNotFound
      render json: {error: "User not found with id #{id}"}, status: :not_found
    end
  end

  def note_params
    params.require(:note).permit(:title, :content, :shared, :attachment)
  end

end
