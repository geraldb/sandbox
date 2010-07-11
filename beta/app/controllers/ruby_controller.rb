class RubyController < ApplicationController
  
  # todo: use a different location for storing generated planet web page?
  
  def index
    render :file => "#{RAILS_ROOT}/public/ruby/index.html", :layout => false
  end
  
end
