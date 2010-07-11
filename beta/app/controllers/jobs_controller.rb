require 'text_captcha'  # todo move to environment.rb

class JobsController < ApplicationController
  
  before_filter :admin_required,
    :only => [:unpublish, :publish, :delete, :edit, :update]
  
  def feed
    @posts = Post.find :all, :order => 'created_at desc', :conditions => 'published = 1', :limit => 8
    render :layout => false
    # @headers["Content-Type"] = "application/xml; charset=utf-8"
  end

  def index
    @title = 'Welcome'
    @posts = Post.find :all, :order => 'created_at desc', :conditions => 'published = 1'
  end

  def upcoming
    @title = 'Upcoming'
    @posts = Post.find :all, :order => 'created_at desc', :conditions => 'published = 0'
    render :action => 'index'
  end

  def unpublish
    @post = Post.find params[:id]
    @post.published = false
    if @post.save
      flash[:notice] = "Unpublished '#{@post.title} @ #{@post.company}'"
    else
      flash[:notice] = "Unpublishing failed. Check logs for details."   
    end
    redirect_to :action => 'index'
  end

  def publish
    @post = Post.find params[:id]
    @post.published = true
    if @post.save
      flash[:notice] = "Published '#{@post.title} @ #{@post.company}'"
    else
      flash[:notice] = "Publishing failed. Check logs for details."   
    end
    redirect_to :action => 'upcoming'
  end

  def delete
    @post = Post.find params[:id]
    flash[:notice] = "Deleted '#{@post.title} @ #{@post.company}'"
    @post.destroy
    # redirect_to :action => 'upcoming'
    redirect_to :back
  end

  def permalink
    if params[:permalink] =~ /(\d+)-.+/
      @post = Post.find $1
    else
      @post = Post.find_by_permalink params[:permalink]
    end
    
    @title = "#{@post.title} @ #{@post.company}"
    render :action => 'show'
  end

  def show
    @post = Post.find params[:id]
    @title = "#{@post.title} @ #{@post.company}"
  end

  def edit
    @post = Post.find params[:id]
    @title = "#{@post.title} @ #{@post.company}"
  end
  
  def new
    @title = 'Add a Job Posting: Step 1 of 2'
    @post = session[:draft_post] || Post.new( :full_time => true, :part_time => true, :contract => true ) 
  end

  def preview
    @title = 'Add a Job Posting: Step 2 of 2'
    if params[:post]
      @post = Post.new params[:post]
      session[:draft_post] = @post
    else
      # redirect from captcha failure; use stored draft post
      @post = session[:draft_post]
    end
    if @post.valid?
      @captcha_guide, @captcha_display = TextCaptcha.generate 
    else
      redirect_to :action => 'new'
    end    
  end
  
  def create
 
    if TextCaptcha.valid?( params[:captcha_guide], params[:captcha] )
      @post = Post.new params[:post]
      if @post.save
        session[:draft_post] = nil
        flash[:notice] = 'Thanks! Job posting successfully saved.'
        redirect_to :action => 'upcoming'
      else
        redirect_to :action => 'new'
      end
    else
      flash[:notice ] = 'Failed to confirm CAPTCHA. Renter CAPTCHA to post.'
      redirect_to :action =>  'preview'   
    end
  end

  def update
    @post = Post.find params[:id]
    if @post.update_attributes params[:post]
      flash[:notice] = 'Changes successfully saved.'
      redirect_to job_path( :permalink => @post.to_permalink )
    else
      render :action => 'edit'
    end
  end

end
