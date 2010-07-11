# == Schema Information
# Schema version: 3
#
# Table name: events
#
#  id         :integer(11)     not null, primary key
#  title      :string(255)     
#  venue      :string(255)     
#  address    :string(255)     
#  occurs_on  :date            
#  start_time :time            
#  web        :string(255)     
#  desc       :text            
#  permalink  :string(255)     
#  published  :boolean(1)      
#  created_at :datetime        
#  updated_at :datetime        
#

class Event < ActiveRecord::Base

  validates_presence_of :title, :venue, :address, :occurs_on, :desc, :web
  validate :has_not_occured
 
 
  def is_in_the_past?
    occurs_on < Date.today
  end
  
  def has_not_occured
    errors.add( 'occurs_on', 'is in the past') if occurs_on && is_in_the_past?
  end

  def to_permalink
    permalink = "#{id}-#{title}-#{venue}"
    permalink = permalink.downcase.gsub( /[\s\.\/]+/, '-' ).gsub( /[^a-zA-Z0-9_-]+/, '' )
    # remove duplicate dashes
    permalink = permalink.gsub( /-{2,}/, '-' )
    # remove trailing dash
    permalink = permalink.gsub( /-$/, '' )
  end

end
