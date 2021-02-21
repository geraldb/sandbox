module WorldDb
  module Model


class Tag
  has_many :wines,    :through => :taggings, :source => :taggable, source_type: 'WineDb::Model::Wine',   class_name: 'WineDb::Model::Wine'
  has_many :wineries, :through => :taggings, :source => :taggable, source_type: 'WineDb::Model::Winery', class_name: 'WineDb::Model::Winery'
end # class Country


  end # module Model
end # module WorldDb
