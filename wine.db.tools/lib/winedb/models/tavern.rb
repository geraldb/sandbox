# encoding: UTF-8

module WineDb
  module Model

class Tavern < ActiveRecord::Base

  belongs_to :winery,  class_name: 'WineDb::Model::Winery', foreign_key: 'winery_id'

  has_many :taggings, :as => :taggable,   class_name: 'WorldDb::Model::Tagging'
  has_many :tags,  :through => :taggings, class_name: 'WorldDb::Model::Tag'

  validates :key, :format => { :with => /^[a-z][a-z0-9]+$/, :message => 'expected two or more lowercase letters a-z or 0-9 digits' }

  ## to be done

end # class Tavern


  end # module Model
end # module WineDb
