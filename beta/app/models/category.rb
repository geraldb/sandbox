# == Schema Information
# Schema version: 3
#
# Table name: categories
#
#  id   :integer(11)     not null, primary key
#  name :string(255)     
#

class Category < ActiveRecord::Base
   has_many :posts
   
  def Category.find_select_options
   [[ '-- Select a Category --', '' ]] + Category.find(:all).map { |cat| [ cat.name, cat.id ] }
  end

  NAMES_IDS = find_select_options

end
