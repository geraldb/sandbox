# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  include TagsHelper

  def page_title
    @title || "no-title-fix-me"
  end
  
  def is_admin?
    session[:admin]
  end
  
end
