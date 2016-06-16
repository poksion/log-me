# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'test/unit'
require_relative '../logger-factory'

class LoggerFactoryTest < Test::Unit::TestCase

  def test_new_instance
    logger = LoggerFactory.newInstance()
    assert_not_nil(logger)
  end

  def test_search
    logger = LoggerFactory.newInstance()
    logger.log_search("신한 카드")
    logger.log_result("신한 카드")
  end
  
  def test_print
    logger = LoggerFactory.newInstance()
    logger.log_print
  end

end