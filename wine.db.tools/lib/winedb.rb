

# 3rd party gems / libs

require 'active_record'   ## todo: add sqlite3? etc.

require 'logutils'
require 'textutils'
require 'worlddb'
require 'persondb'


### our own code

require 'winedb/version'  # let it always go first
require 'winedb/schema'

require 'winedb/models/forward'

require 'winedb/models/worlddb/country'
require 'winedb/models/worlddb/region'
require 'winedb/models/worlddb/city'

require 'winedb/models/tag'

require 'winedb/models/family'
require 'winedb/models/grape'
require 'winedb/models/person'
require 'winedb/models/shop'
require 'winedb/models/tavern'
require 'winedb/models/variety'
require 'winedb/models/vineyard'
require 'winedb/models/vintage'
require 'winedb/models/wine'
require 'winedb/models/winery'

require 'winedb/matcher'
require 'winedb/reader'


module WineDb
  
  def self.banner
    "winedb/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end

  def self.data_path
    "#{root}/data"
  end


  def self.create
    CreateDb.new.up

    WineDb::Model::Prop.create!( key: 'db.schema.wine.version', value: VERSION )
  end


  def self.read( ary, include_path )
    reader = Reader.new( include_path )
    ary.each do |name|
      reader.load( name )
    end
  end

  def self.read_setup( setup, include_path, opts={} )
    reader = Reader.new( include_path, opts )
    reader.load_setup( setup )
  end

  def self.read_all( include_path, opts={} )  # load all builtins (using plain text reader); helper for convenience
    read_setup( 'setups/all', include_path, opts )
  end # method read_all

  def self.read_builtin
    read_setup( 'setups/all', data_path )
  end

  def self.delete!
    ## fix/todo: move into deleter class (see worlddb,sportdb etc.)
    Model::Grape.delete_all
    Model::Family.delete_all
    Model::Variety.delete_all
    Model::Vineyard.delete_all
    Model::Shop.delete_all
    Model::Tavern.delete_all
    Model::Vintage.delete_all
    Model::Wine.delete_all
    Model::Winery.delete_all
  end
  
  def self.tables
    ## fix/todo: move into stats class (see worlddb,sportdb etc.)
    puts "  #{Model::Grape.count} grapes"
    puts "  #{Model::Family.count} (wine) families"
    puts "  #{Model::Variety.count} (wine) varieties"
    puts "  #{Model::Vineyard.count} vineyards"
    puts "  #{Model::Shop.count} shops (vinothek/enotecia)"
    puts "  #{Model::Tavern.count} taverns (heurige)"
    puts "  #{Model::Vintage.count} vintages"
    puts "  #{Model::Wine.count} wines"
    puts "  #{Model::Winery.count} wineries"
  end


end  # module WineDb


puts WineDb.banner    # say hello
