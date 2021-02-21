# encoding: UTF-8

module WineDb
  module Model

class Vineyard < ActiveRecord::Base

  has_many :wines,  class_name: 'WineDb::Model::Wine',   foreign_key: 'vineyard_id'

  ## to be done

end # class Vineyard

  end # module Model
end # module WineDb
