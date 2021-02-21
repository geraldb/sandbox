### forward references
##   require first to resolve circular references


module WineDb
  module Model

  ## todo: why? why not use include WorldDb::Models here???

  Continent = WorldDb::Model::Continent
  Country   = WorldDb::Model::Country
  Region    = WorldDb::Model::Region
  City      = WorldDb::Model::City

  Tag       = WorldDb::Model::Tag
  Tagging   = WorldDb::Model::Tagging

  Prop      = WorldDb::Model::Prop

  Person    = PersonDb::Model::Person


  class Wine < ActiveRecord::Base ; end
  class Winery < ActiveRecord::Base ; end
  class Grape < ActiveRecord::Base ; end
  class Family < ActiveRecord::Base ; end
  class Variety < ActiveRecord::Base ; end
  class Vineyard < ActiveRecord::Base ; end
  class Shop < ActiveRecord::Base ; end
  class Tavern < ActiveRecord::Base ; end
  class Vintage < ActiveRecord::Base ; end

  end # module Model

  ## note: for convenciene (and compatibility) add alias Models for Model namespace
  ##  e.g lets you use include WineDb::Models
  Models = Model

end # module WineDb


module WorldDb
  module Model

  Wine   = WineDb::Model::Wine
  Winery = WineDb::Model::Winery

  end
end

module PersonDb
  module Model

  Wine   = WineDb::Model::Wine
  Winery = WineDb::Model::Winery

  end
end

