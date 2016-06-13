# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'test/unit'
require_relative '../config-loader'
require_relative '../lib/os-checker'

class OsCheckerMock
  include OsChecker
end

class ConfigLoaderTest < Test::Unit::TestCase

  def test_include
    config_loader = ConfigLoader.new
    os_checker_mock = OsCheckerMock.new
    assert_equal(config_loader.run_on_mac?, os_checker_mock.run_on_mac?)
  end

  def test_load
    config_loader = ConfigLoader.new
    assert_not_nil(config_loader)
    config_loader.load
  end

end