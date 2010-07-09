class PostsController < ApplicationController
  
  def index
    @posts = Post.find :all
  end

  def show
    @post = Post.find( params[:id] )
  end
  
  def search
    @posts = Post.find :all, :conditions => [ "description like ?", "%#{params[:query]}%" ]
  end

end
