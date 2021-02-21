# encoding: UTF-8

module WineDb


class Reader

  include LogUtils::Logging

  include WineDb::Models

  include WorldDb::Matcher   ## fix: move to WineDb::Matcher module ??? - cleaner?? why? why not?
  include WineDb::Matcher # lets us use match_teams_for_country etc.

  attr_reader :include_path


  def initialize( include_path, opts = {} )
    @include_path = include_path
  end


  def load_setup( name )
    path = "#{include_path}/#{name}.yml"

    logger.info "parsing data '#{name}' (#{path})..."

    reader = FixtureReader.new( path )

    reader.each do |fixture_name|
      load( fixture_name )
    end
  end # method load_setup


  def load( name )

    #  grapes - allow e.g.
    #   - /grapes or /grapes-red or /grapes-white
    if name =~ /(^|\/)grapes(-(red|white))?$/
      load_grapes( name )
    elsif match_wines_for_country_n_region( name ) do |country_key, region_key|
        ### fix: use region_key too
        load_wines_for_country( country_key, name )
       end
    elsif match_wines_for_country( name ) do |country_key|
            load_wines_for_country( country_key, name )
          end
    elsif match_wineries_for_country_n_region( name ) do |country_key, region_key|
        ### fix: use region_key too
            load_wineries_for_country( country_key, name )
          end
    elsif match_wineries_for_country( name ) do |country_key|
            load_wineries_for_country( country_key, name )
          end
    else
      logger.error "unknown wine.db fixture type >#{name}<"
      # todo/fix: exit w/ error
    end
  end


  def load_grapes( name, more_attribs={} )
    if name =~ /(^|\/)grapes-red$/
      more_attribs[ :red ] = true
    elsif name =~ /(^|\/)grapes-white$/
      more_attribs[ :white ] = true
    else
      # do nothing
    end

    load_grapes_worker( name, more_attribs )
  end

  def load_grapes_worker( name, more_attribs={} )
    reader = ValuesReaderV2.new( name, include_path, more_attribs )

    reader.each_line do |new_attributes, values|
      Grape.create_or_update_from_attribs( new_attributes, values )
    end # each_line
  end


  def load_wines_for_country( country_key, name, more_attribs={} )
    country = Country.find_by_key!( country_key )
    logger.debug "Country #{country.key} >#{country.title} (#{country.code})<"

    more_attribs[ :country_id ] = country.id

    more_attribs[ :txt ] = name  # store source ref

    load_wines_worker( name, more_attribs )
  end



  def load_wines_worker( name, more_attribs={} )
    reader = ValuesReaderV2.new( name, include_path, more_attribs )

    ### todo: cleanup - check if [] works for build_title...
    #     better cleaner way ???
    if more_attribs[:region_id].present?
      known_wineries_source = Winery.where( region_id:  more_attribs[:region_id] )
    elsif more_attribs[:country_id].present?
      known_wineries_source = Winery.where( country_id: more_attribs[:country_id] )
    else
      logger.warn "no region or country specified; use empty winery ary for header mapper"
      known_wineries_source = []
    end

    known_wineries = TextUtils.build_title_table_for( known_wineries_source )

    reader.each_line do |new_attributes, values|

      ## note: check for header attrib; if present remove
      ### todo: cleanup code later
      ## fix: add to new_attributes hash instead of values ary
      ##   - fix: match_winery()   move region,city code out of values loop for reuse at the end
      if new_attributes[:header].present?
        winery_line = new_attributes[:header].dup   # note: make sure we make a copy; will use in-place string ops
        new_attributes.delete(:header)   ## note: do NOT forget to remove from hash!

        logger.debug "  trying to find winery in line >#{winery_line}<"
        ## todo: check what map_titles_for! returns (nothing ???)
        TextUtils.map_titles_for!( 'winery', winery_line, known_wineries )
        winery_key = TextUtils.find_key_for!( 'winery', winery_line )
        logger.debug "  winery_key = >#{winery_key}<"
        unless winery_key.nil?
          ## bingo! add winery_id upfront, that is, as first value in ary
          values = values.unshift "winery:#{winery_key}"
        end
      end

      Wine.create_or_update_from_attribs( new_attributes, values )
    end # each_line
  end


  def load_wineries_for_country( country_key, name, more_attribs={} )
    country = Country.find_by_key!( country_key )
    logger.debug "Country #{country.key} >#{country.title} (#{country.code})<"

    more_attribs[ :country_id ] = country.id

    more_attribs[ :txt ] = name  # store source ref

    load_wineries_worker( name, more_attribs )
  end

  def load_wineries_worker( name, more_attribs={} )
    reader = ValuesReaderV2.new( name, include_path, more_attribs )

    reader.each_line do |new_attributes, values|
      
      #######
      # fix: move to (inside)
      #    Winery.create_or_update_from_attribs ||||
      ## note: group header not used for now; do NOT forget to remove from hash!
      if new_attributes[:header].present?
        logger.warn "removing unused group header #{new_attributes[:header]}"
        new_attributes.delete(:header)   ## note: do NOT forget to remove from hash!
      end
      
      Winery.create_or_update_from_attribs( new_attributes, values )
    end # each_line
  end

end # class Reader
end # module WineDb
