# encoding: utf-8

require 'helper'


class TestWineries < MiniTest::Unit::TestCase

  def setup  # runs before every test
    PersonDb.delete!
    WineDb.delete!   # always clean-out tables
  end


  def test_load_winery_values

    key = 'antonbauer'

    values = [
      key,
      'Anton Bauer (1971)',
      'www.antonbauer.at',
      'Neufang 42 // 3483 Feuersbrunn',
      '25 ha'  ### todo: make sure it will not get matched as tag
    ]

    more_attribs = {
      country_id: AT.id
    }

    wy = Winery.create_or_update_from_values( values, more_attribs )

    wy2 = Winery.find_by_key!( key )
    assert_equal wy.id, wy2.id

    assert_equal 'Anton Bauer',       wy.title
    assert_equal AT.id,               wy.country_id
    assert_equal AT.title,            wy.country.title
    assert_equal 'www.antonbauer.at', wy.web
    assert_equal 'Neufang 42 // 3483 Feuersbrunn', wy.address

    ## check for auto-create person
    p = Person.find_by_key!( 'antonbauer' ) 
    assert_equal 'Anton Bauer', p.name
  end


end # class TestModels

