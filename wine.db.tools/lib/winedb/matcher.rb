# encoding: UTF-8

module WineDb


module Matcher

  def match_wines_for_country( name, &blk )
    ## check: allow/add synonyms e.g. weine, vinos etc. ???
    match_xxx_for_country( name, 'wines', &blk )
  end

  def match_wines_for_country_n_region( name, &blk )
    match_xxx_for_country_n_region( name, 'wines', &blk )
  end

  def match_wineries_for_country( name, &blk )
    match_xxx_for_country( name, 'wineries', &blk )
  end

  def match_wineries_for_country_n_region( name, &blk )
    ## check: allow/add synonyms e.g. producers ? weingueter ??
    match_xxx_for_country_n_region( name, 'wineries', &blk )
  end

  ## for now vineyards, shops, taverns require country n region
  def match_vineyards_for_country_n_region( name, &blk )
    match_xxx_for_country_n_region( name, 'vineyards', &blk )
  end

  def match_shops_for_country_n_region( name, &blk )
    ## check: allow/add synonyms e.g. vinotheken, enotecas
    match_xxx_for_country_n_region( name, 'shops', &blk )
  end

  def match_taverns_for_country_n_region( name, &blk )
    ## also try synonyms e.g. heurige (if not match for taverns)
    found = match_xxx_for_country_n_region( name, 'taverns', &blk )
    found = match_xxx_for_country_n_region( name, 'heurige', &blk ) unless found
    found
  end


end # module Matcher
end # module WineDb