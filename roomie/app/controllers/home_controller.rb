class HomeController < ApplicationController

  def index
     render :layout => 'start'
  end

  def welcome
     render :action => 'index'
  end
end
