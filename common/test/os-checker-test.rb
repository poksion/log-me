# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'test/unit'
require_relative '../lib/os-checker'

class OsCheckerMock
  include OsChecker
end

class OsCheckerTest < Test::Unit::TestCase

  def test_include
    os_checker_mock = OsCheckerMock.new
    assert_equal((/darwin/ =~ RUBY_PLATFORM) != nil, os_checker_mock.run_on_mac?) 
  end

end