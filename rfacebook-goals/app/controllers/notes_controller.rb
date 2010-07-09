class NotesController < ApplicationController

  def debug
    render_with_facebook_debug_panel
  end

  def index
    @notes = Note.find(:all)
  end

  def show
    @note = Note.find(params[:id])
  end

  def new
    @note = Note.new
  end

  def edit
    @note = Note.find(params[:id])
  end

  def create
    @note = Note.new(params[:note])

    if @note.save
      flash[:notice] = 'Goal successfully added.'
      redirect_to :action => 'show', :id => @note
    else
      render :action => "new" 
    end

  end

  def update
    @note = Note.find(params[:id])

    if @note.update_attributes(params[:note])
      flash[:notice] = 'Goal successfully updated.'
      redirect_to :action => 'show', :id => @note
    else
      render :action => "edit" 
    end
  end

end
