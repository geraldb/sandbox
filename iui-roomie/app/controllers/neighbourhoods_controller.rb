class NeighbourhoodsController < ApplicationController

  def index
    @neighbourhoods = Neighbourhood.find :all
  end

  def show
    @neighbourhood = Neighbourhood.find( params[:id] )
  end

 end
