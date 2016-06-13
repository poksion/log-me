# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'test/unit'
require_relative '../lib/logger-factory'

class LoggerFactoryTest < Test::Unit::TestCase

  def test_new_instance
    logger = LoggerFactory.newInstance()
    assert_not_nil(logger)
  end

end