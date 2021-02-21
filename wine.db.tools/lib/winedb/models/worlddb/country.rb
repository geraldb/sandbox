module WorldDb
  module Model


class Country
  has_many :wines,     class_name: 'WineDb::Model::Wine',   foreign_key: 'country_id'
  has_many :wineries,  class_name: 'WineDb::Model::Winery', foreign_key: 'country_id'
  has_many :taverns,   class_name: 'WineDb::Model::Tavern', foreign_key: 'country_id'
  has_many :shops,     class_name: 'WineDb::Model::Shop',   foreign_key: 'country_id'
end # class Country


  end # module Model
end # module WorldDb

