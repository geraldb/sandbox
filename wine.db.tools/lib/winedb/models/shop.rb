# encoding: UTF-8

module WineDb
  module Model

class Shop < ActiveRecord::Base

  has_many :taggings, :as => :taggable,   class_name: 'WorldDb::Model::Tagging'
  has_many :tags,  :through => :taggings, class_name: 'WorldDb::Model::Tag'

  validates :key, :format => { :with => /^[a-z][a-z0-9]+$/, :message => 'expected two or more lowercase letters a-z or 0-9 digits' }

  ## to be done

end # class Shop


  end # module Model
end # module WineDb
