# encoding: utf-8


require 'helper'


class TestWines < MiniTest::Unit::TestCase

  def setup  # runs before every test
    PersonDb.delete!
    WineDb.delete!   # always clean-out tables
  end


  def test_load_wine_values
 
    key = 'gruenerveltlinerspiegel'

    values = [
      'Grüner Veltliner Spiegel',
      'gv'
    ]

    more_attribs = {
      country_id: AT.id
    }

    wine = Wine.create_or_update_from_values( values, more_attribs )

    wine2 = Wine.find_by_key!( key )
    assert_equal wine2.id, wine.id

    assert_equal values[0],  wine.title
    assert_equal AT.id,      wine.country_id
    assert_equal AT.title,   wine.country.title
  end


end # class TestWines

