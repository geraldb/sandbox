# == Schema Information
# Schema version: 3
#
# Table name: services
#
#  id           :integer(11)     not null, primary key
#  group_id     :integer(11)     
#  scategory_id :integer(11)     
#  link         :string(255)     
#  created_at   :datetime        
#  updated_at   :datetime        
#

class Service < ActiveRecord::Base
  belongs_to :group
  belongs_to :scategory
  
  validates_presence_of  :scategory, :link
  
  def to_s
    "#{scategory.nil? ? '-/-':scategory.name}:#{link.nil? ? '-/-':link}"
  end
end
