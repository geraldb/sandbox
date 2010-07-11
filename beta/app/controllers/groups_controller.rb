class GroupsController < ApplicationController

  before_filter :admin_required, :except => [:index, :show]

  def index
    @title  = 'Vancouver Tech & Media Groups & Organizations'
    @groups = Group.find :all, :order => 'gcategory_id, name'
  end

  def new
    @title = 'Add a Group'
    @group = Group.new 
  end

  def add_service
    @group = Group.find params[:id]
           
    @service = Service.new params[ :service ] 
    if @service.valid?
      @group.services << @service 
      flash.now[:notice] = 'Service successfully added.'
    else
      flash.now[:notice] = "Failed to add service."
    end
      
    # render :inline => "<p>result:</p><pre>#{params.to_yaml}</pre>"
     
    render :update do |page|
      page[ 'flash' ].replace_html    render :partial => 'layouts/flash', :locals => { :flash => flash } 
      page[ 'services' ].replace_html  render :partial => 'edit_services'
    end
  end

  def create
    @group = Group.new params[:group]
    if @group.save
      flash[:notice] = 'Group successfully created.'
      redirect_to :action => 'edit', :id => @group
    else
      render :action => 'new'
    end
  end
  
  def update
    @group = Group.find params[:id]
    if @group.update_attributes params[:group]
      flash[:notice] = 'Group successfully updated.'
      redirect_to :action => 'show', :id => @group
    else
      render :action => 'edit'
    end
  end

  def delete
  end

  def show
    @group = Group.find params[:id]
  end

  def edit
    @group = Group.find params[:id] 
  end
  
end
