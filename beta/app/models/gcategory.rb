# == Schema Information
# Schema version: 3
#
# Table name: gcategories
#
#  id   :integer(11)     not null, primary key
#  name :string(255)     
#

class Gcategory < ActiveRecord::Base
  has_many :groups
  
  def Gcategory.find_select_options
   [[ '-- Select a Category --', '' ]] + Gcategory.find(:all).map { |cat| [ cat.name, cat.id ] }
  end

  NAMES_IDS = find_select_options
  
end
