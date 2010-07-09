class CommentsController < ApplicationController

 def new
    @comment = Comment.new
    @comment.note_id = params[:note_id]
  end

  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      flash[:notice] = 'Comment successfully posted.'
      redirect_to :controller => 'notes', :action => 'show', :id => @comment.note
    else
      render_action 'new' 
    end
  end

end
