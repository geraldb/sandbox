# == Schema Information
# Schema version: 3
#
# Table name: posts
#
#  id          :integer(11)     not null, primary key
#  company     :string(255)     
#  web         :string(255)     
#  title       :string(255)     
#  desc        :text            
#  contact     :string(255)     
#  full_time   :boolean(1)      
#  part_time   :boolean(1)      
#  contract    :boolean(1)      
#  permalink   :string(255)     
#  published   :boolean(1)      
#  category_id :integer(11)     
#  created_at  :datetime        
#  updated_at  :datetime        
#

class Post < ActiveRecord::Base
  belongs_to :category
   
  validates_presence_of :company, :web, :title, :desc, :contact, :category
   
  def job_types
    types = []
    types << 'Full Time'  if self.full_time?
    types << 'Part Time'  if self.part_time?
    types << 'Contract'   if self.contract?
    types
  end
  
  def self.recent
    find :all, :conditions => 'published = 1',
         :limit => 5, :order => 'created_at DESC'
  end
  
  
  def to_permalink
    permalink = "#{id}-#{title}-#{company}"
    permalink = permalink.downcase.gsub( /[\s\.\/]+/, '-' ).gsub( /[^a-zA-Z0-9_-]+/, '' )
    # remove duplicate dashes
    permalink = permalink.gsub( /-{2,}/, '-' )
    # remove trailing dash
    permalink = permalink.gsub( /-$/, '' )
  end

end
