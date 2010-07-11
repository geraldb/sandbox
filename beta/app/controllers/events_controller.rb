class EventsController < ApplicationController

  before_filter :admin_required
  
  def index
    @title = 'Events'
    @events = Event.find :all, :order => 'occurs_on DESC'
  end

  def permalink
    if params[:permalink] =~ /(\d+)-.+/
      @event = Event.find $1
    else
      @event = Event.find_by_permalink params[:permalink]
    end
    
    @title = "#{@event.title} @ #{@event.venue}"
    render :action => 'show'
  end

  def new
    @title = 'Add an Event: Step 1 of 2'
    @event = session[:draft_event] || Event.new 
  end

  def preview
    @title = 'Add an Event: Step 2 of 2'
    @event = Event.new params[:event] 
    session[:draft_event] = @event
    unless @event.valid?
       redirect_to :action => 'new'
    end
  end

  def show
    @event = Event.find params[:id]
  end

  def edit
    @event = Event.find params[:id]
  end
  
  def update
    @event = Event.find params[:id]
    if @event.update_attributes params[:event]
      flash[:notice] = 'Event listing successfully updated.'
      redirect_to event_path( :permalink => @event.to_permalink )
    else
      render :action => 'edit'
    end
  end
  
  def create
    @event = Event.new params[:event]
    if @event.save
      session[:draft_event] = nil
      flash[:notice] = 'Thanks! Event listing successfully saved.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def delete
    @event = Event.find params[:id]
    flash[:notice] = "Deleted '#{@event.title} @ #{@event.venue}'"
    @event.destroy
    redirect_to :back
  end
  
end


