class Neighbourhood < ActiveRecord::Base

  has_many :posts
  
  AREAS = %w(Westside Eastside Downtown)

  validates_presence_of :name, :area
  validates_inclusion_of :area, :in => AREAS

  
end
