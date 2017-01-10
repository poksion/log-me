# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'test/unit'
require_relative '../lib/formatted-logger'

class LoggerFactoryTest < Test::Unit::TestCase

  def test_new_instance_and_print
    logger = LoggerFactory.newInstance()
    assert_not_nil(logger)

    logger.log_print
  end

  def test_search
    logger = LoggerFactory.newInstance()
    logger.log("신한 카드", :search)
    logger.log("신한 카드", :result)
  end

end