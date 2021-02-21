module WorldDb
  module Model

class City
  has_many :wines,     class_name: 'WineDb::Model::Wine',     foreign_key: 'city_id'
  has_many :wineries,  class_name: 'WineDb::Model::Winery',   foreign_key: 'city_id'
  has_many :taverns,   class_name: 'WineDb::Model::Tavern',   foreign_key: 'city_id'
  has_many :shops,     class_name: 'WineDb::Model::Shop',     foreign_key: 'city_id'
  has_many :vineyards, class_name: 'WineDb::Model::Vineyard', foreign_key: 'city_id'
end # class Country


  end # module Model
end # module WorldDb
