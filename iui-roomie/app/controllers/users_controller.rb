class UsersController < ApplicationController

  def new
    render :layout => false
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default( welcome_path )
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new', :layout => false
    end
  end

end
