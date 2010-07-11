# == Schema Information
# Schema version: 3
#
# Table name: scategories
#
#  id   :integer(11)     not null, primary key
#  name :string(255)     
#

class Scategory < ActiveRecord::Base
  has_many :services
   
  def Scategory.find_select_options
   [[ '-- Select a Service --', '' ]] + Scategory.find(:all).map { |cat| [ cat.name, cat.id ] }
  end

  NAMES_IDS = find_select_options
   
end
