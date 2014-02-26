require_relative '../category_manager.rb'
require "test/unit"

def return_4
    return 4
end

def return_6
    return 6
end

class TestSimpleNumber < Test::Unit::TestCase
 
  def test_simple
    assert_equal(4, return_4 )
    assert_equal(3, return_6 )
  end
 
end