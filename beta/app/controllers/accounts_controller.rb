class AccountsController < ApplicationController

  def login
    @title = 'Admin Sign In'
  end
  
  def authenticate
    if params[:pass] == 'topsecret'
        session[:admin] = true
        flash[:notice] = 'Welcome back! Successfully signed in.'
        redirect_to :controller => 'jobs'
    else
        flash[:notice] = 'Invalid passphrase. Try again.'
        redirect_to :action => 'login'
    end
  end
  
  def logout
    flash[:notice] = 'Goodbye! Successfully signed out.'
    session[:admin] = nil
    redirect_to :controller => 'jobs'
  end
end
