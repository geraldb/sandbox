# encoding: utf-8


require 'helper'

### todo/fix: move to worlddb along with fixture matcher module!!

class TestFixtureMatchers < MiniTest::Unit::TestCase

  include WorldDb::Matcher
  include WineDb::Matcher


  def test_country

    wines_at = [
      'europe/at/wines',
      'europe/at-austria/wines',
      'at-austria/wines',
      'at-austria!/wines',
      '1--at-austria--central/wines',
      'europe/1--at-austria--central/wines'
    ]

    wines_at.each do |name|
      found = match_wines_for_country( name ) do |country_key|
        assert( country_key == 'at')
      end
      assert( found == true )
    end

    wineries_at = [
      'europe/at/wineries',
      'europe/at-austria/wineries',
      'at-austria/wineries',
      'at-austria!/wineries',
      '1--at-austria--central/wineries',
      'europe/1--at-austria--central/wineries'
    ]

    wineries_at.each do |name|
      found = match_wineries_for_country( name ) do |country_key|
        assert( country_key == 'at')
      end
      assert( found == true )
    end
  end # method test_country


  def test_country_n_region

    wines_at = [
      'europe/at-austria/n-niederoesterreich/wines',
      'at-austria/n-niederoesterreich/wines',
      'at-austria!/n-niederoesterreich/wines',
      '1--at-austria--central/1--n-niederoesterreich--eastern/wines',
      'europe/1--at-austria--central/1--n-niederoesterreich--eastern/wines'
    ]

    wines_at.each do |name|
      found = match_wines_for_country_n_region( name ) do |country_key,region_key|
        assert( country_key == 'at')
        assert( region_key  == 'n' )
      end
      assert( found == true )
    end

    wineries_at = [
      'europe/at-austria/n-niederoesterreich/wineries',
      'at-austria/n-niederoesterreich/wineries',
      'at-austria!/n-niederoesterreich/wineries',
      '1--at-austria--central/1--n-niederoesterreich--eastern/wineries',
      'europe/1--at-austria--central/1--n-niederoesterreich--eastern/wineries'
    ]

    wineries_at.each do |name|
      found = match_wineries_for_country_n_region( name ) do |country_key,region_key|
        assert( country_key == 'at')
        assert( region_key  == 'n' )
      end
      assert( found == true )
    end
  end # method test_country_n_region


  def test_wine_region ### sub region e.g. wagram, wachau, etc.

    wines_at = [
      'at-austria!/1--n-niederoesterreich--eastern/wines',
      'at-austria!/1--n-niederoesterreich--eastern/wagram/wines',
      'at-austria!/1--n-niederoesterreich--eastern/wagram/feuersbrunn--wines',
      'at-austria!/1--n-niederoesterreich--eastern/wagram/feuersbrunn/wines',
      'at-austria!/1--n-niederoesterreich--eastern/wagram/wagram--wines',
      'at-austria!/1--n-niederoesterreich--eastern/wagram/wagram/wines',
      'at-austria!/1--n-niederoesterreich--eastern/wagram--wines',
      'at-austria!/1--n-niederoesterreich--eastern/wagram--feuersbrunn--wines',
      'at-austria!/1--n-niederoesterreich--eastern/wagram--wagram--wines'
    ]

    wines_at.each do |name|
      found = match_wines_for_country_n_region( name ) do |country_key,region_key|
        assert( country_key == 'at')
        assert( region_key  == 'n' )
      end
      assert( found == true )
    end

    wineries_at = [
      'at-austria!/1--n-niederoesterreich--eastern/wineries',
      'at-austria!/1--n-niederoesterreich--eastern/wagram--wineries',
      'at-austria!/1--n-niederoesterreich--eastern/wagram/wineries',
      'at-austria!/1--n-niederoesterreich--eastern/wagram--feuersbrunn--wineries',
      'at-austria!/1--n-niederoesterreich--eastern/wagram/feuersbrunn--wineries',
      'at-austria!/1--n-niederoesterreich--eastern/wagram/feuersbrunn/wineries',
      'at-austria!/1--n-niederoesterreich--eastern/wagram--wagram--wineries'
    ]

    wineries_at.each do |name|
      found = match_wineries_for_country_n_region( name ) do |country_key,region_key|
        assert( country_key == 'at')
        assert( region_key  == 'n' )
      end
      assert( found == true )
    end
  end # method test_wine_region


  def test_misc
    taverns   = [
      'at-austria!/1--n-niederoesterreich--eastern/wagram/feuersbrunn--taverns',
      'at-austria!/1--n-niederoesterreich--eastern/wagram/feuersbrunn--heurige'
    ]

    taverns.each do |tavern|
      found = match_taverns_for_country_n_region( tavern ) do |country_key,region_key|
        assert( country_key == 'at')
        assert( region_key  == 'n' )
      end
      assert( found == true )
    end


    vineyards = 'at-austria!/1--n-niederoesterreich--eastern/wagram/feuersbrunn--vineyards'
    shops     = 'at-austria!/1--n-niederoesterreich--eastern/wagram/shops'

    found = match_vineyards_for_country_n_region( vineyards ) do |country_key,region_key|
        assert( country_key == 'at')
        assert( region_key  == 'n' )
    end
    assert( found == true )

    found = match_shops_for_country_n_region( shops ) do |country_key,region_key|
        assert( country_key == 'at')
        assert( region_key  == 'n' )
    end
    assert( found == true ) 
  end



end # class TestFixtureMatchers