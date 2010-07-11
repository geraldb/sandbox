class AjaxController < ApplicationController
  
  # todo: use a different location for storing generated planet web page?
  
  def index
    render :file => "#{RAILS_ROOT}/public/ajax/index.html", :layout => false
  end
  
end
