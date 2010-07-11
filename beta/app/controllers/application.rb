# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery  :secret => '026fbcc16092fcf7652be6d2dcb2dad0'
  
  def is_admin?
    session[:admin]
  end
  
  def admin_required
     return true if is_admin?
     
     session[:return_to] = request.request_uri
     flash[:notice] = "Admin access required for '#{request.request_uri}'"
     redirect_to accounts_path
     return false
  end
end
