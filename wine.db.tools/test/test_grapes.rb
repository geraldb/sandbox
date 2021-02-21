# encoding: utf-8


require 'helper'


class TestGrapes < MiniTest::Unit::TestCase

  def setup  # runs before every test
    PersonDb.delete!
    WineDb.delete!   # always clean-out tables
  end


  def test_load_grape_values
 
    key = 'gv'

    values = [
      key,
      'Grüner Veltliner',
      'gv'
    ]

    more_attribs = {
      white: true
    }

    grape = Grape.create_or_update_from_values( values, more_attribs )

    grape2 = Grape.find_by_key!( key )
    assert_equal grape2.id, grape.id

    assert_equal values[1],  grape.title
    assert_equal true,       grape.white
    assert_equal false,      grape.red
  end


end # class TestGrapes

