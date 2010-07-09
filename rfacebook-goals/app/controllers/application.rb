# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_goals_session_id'
  
  before_filter :require_facebook_login, :set_user
  
  def set_user
    @current_fb_user_id = fbsession.session_user_id
  end
    
end
