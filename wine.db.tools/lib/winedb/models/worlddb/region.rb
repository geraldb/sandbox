module WorldDb
  module Model

class Region
  has_many :wines,    class_name: 'WineDb::Model::Wine',   foreign_key: 'region_id'
  has_many :wineries, class_name: 'WineDb::Model::Winery', foreign_key: 'region_id'
  has_many :taverns,  class_name: 'WineDb::Model::Tavern', foreign_key: 'region_id'
  has_many :shops,    class_name: 'WineDb::Model::Shop',   foreign_key: 'region_id'
end # class Region

  end # module Model
end # module WorldDb
