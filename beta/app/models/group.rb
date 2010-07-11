# == Schema Information
# Schema version: 3
#
# Table name: groups
#
#  id           :integer(11)     not null, primary key
#  name         :string(255)     
#  desc         :text            
#  permalink    :string(255)     
#  published    :boolean(1)      
#  gcategory_id :integer(11)     
#  created_at   :datetime        
#  updated_at   :datetime        
#

class Group < ActiveRecord::Base
  
  acts_as_taggable
  
  has_many   :services
  belongs_to :gcategory
  
  validates_presence_of :name, :gcategory

end
