# encoding: utf-8

#######################################
# build script (Ruby make)
#
#  use:
#   $ rake   or
#   $ rake build     - to build beer.db from scratch
#
#   $ rake update    - to update beer.db
#
#   $ rake -T        - show all tasks


BUILD_DIR = "./build"

# -- output db config
WINE_DB_PATH = "#{BUILD_DIR}/wine.db"

# -- input repo sources config
OPENWINE_ROOT = ".."

AT_INCLUDE_PATH               = "#{OPENWINE_ROOT}/at-austria"


DB_CONFIG = {
  adapter:    'sqlite3',
  database:   WINE_DB_PATH
}


#######################
#  print settings

settings = <<EOS
*****************
settings:
  AT_INCLUDE_PATH:           #{AT_INCLUDE_PATH}
*****************
EOS

puts settings




task :default => :build

directory BUILD_DIR


task :clean do
  rm WINE_DB_PATH if File.exists?( WINE_DB_PATH )
end


task :env => BUILD_DIR do
  require 'winedb'   ### NB: for local testing use rake -I ./lib dev:test e.g. do NOT forget to add -I ./lib
  require 'logutils/db'

  LogUtils::Logger.root.level = :info

  pp DB_CONFIG
  ActiveRecord::Base.establish_connection( DB_CONFIG )
end

task :create => :env do
  LogDb.create
  WorldDb.create
  PersonDb.create
  WineDb.create
end


task :importworld => :env do
  # populate world tables
  ## WorldDb.read_setup( 'setups/sport.db.admin', WORLD_DB_INCLUDE_PATH, skip_tags: true )

  Country = WorldDb::Model::Country
  Region  = WorldDb::Model::Region
  City    = WorldDb::Model::City

  at          = Country.create!( key: 'at', title: 'Austria', code: 'AUT', pop: 0, area: 0 )
  n           = Region.create!( key: 'n', title: 'Niederösterreich', country_id: at.id )

  feuersbrunn = City.create!( key: 'feuersbrunn', title: 'Feuersbrunn', country_id: at.id, region_id: n.id )
  wagram      = City.create!( key: 'wagram', title: 'Wagram', country_id: at.id, region_id: n.id )
end


task :importbuiltin => :env do
  WineDb.read_builtin    ## load grapes, families, etc.
  LogUtils::Logger.root.level = :debug
end


task :at => :importbuiltin do
  WineDb.read_setup( 'setups/all', AT_INCLUDE_PATH )
end


#########################################################
# note: change deps to what you want to import for now

task :importwine => [:at] do
  # do nothing here for now
end


task :deletewine => :env do
  PersonDb.delete!   # note: also delete all winemakers
  WineDb.delete!
end


desc 'build wine.db from scratch (default)'
task :build => [:clean, :create, :importworld, :importwine] do
  puts 'Done.'
end

desc 'update wine.db'
task :update => [:deletewine, :importwine] do
  puts 'Done.'
end


desc 'build book (draft version) - The Free Wine Guide - from wine.db'
task :book => :env do

  PAGES_DIR = "#{BUILD_DIR}/pages"  # use PAGES_OUTPUT_DIR or PAGES_ROOT ??

  require './scripts/book'


  build_book()                # multi-page version
  ## build_book( inline: true )  # all-in-one-page version a.k.a. inline version

  puts 'Done.'
end


desc 'build book (release version) - The Free Wine Guide - from wine.db'
task :publish => :env do

  PAGES_DIR = "../book/_pages"  # use PAGES_OUTPUT_DIR or PAGES_ROOT ??

  require './scripts/book'

  build_book()                # multi-page version
  ## build_book( inline: true )  # all-in-one-page version a.k.a. inline version

  puts 'Done.'
end


desc 'print versions of gems'
task :about => :env do
  puts ''
  puts 'gem versions'
  puts '============'
  puts "textutils  #{TextUtils::VERSION}     (#{TextUtils.root})"
  puts "worlddb    #{WorldDb::VERSION}     (#{WorldDb.root})"
  puts "persondb   #{PersonDb::VERSION}     (#{PersonDb.root})"  
  puts "winedb     #{WineDb::VERSION}     (#{WineDb.root})"

  ## todo - add LogUtils  LogDb ??  - check for .root too
end


desc 'print stats for beer.db tables/records'
task :stats => :env do
  puts ''
  puts 'world.db'
  puts '========'
  WorldDb.tables

  puts ''
  puts 'person.db'
  puts '======='
  PersonDb.tables

  puts ''
  puts 'wine.db'
  puts '======='
  WineDb.tables
end


