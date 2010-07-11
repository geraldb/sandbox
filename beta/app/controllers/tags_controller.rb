class TagsController < ApplicationController

  def index
    @title = 'Tags'
    @tags = Group.tag_counts( :order => 'name' )
  end
  
  def permalink
    @title = "Tagged '#{params[:tag]}'"
    
    @groups = Group.find_tagged_with params[:tag] 
    
    render :action => 'show'
  end
  
end
