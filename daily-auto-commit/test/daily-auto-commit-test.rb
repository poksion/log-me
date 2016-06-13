# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'test/unit'
require_relative '../daily-auto-committer'
require_relative '../lib/daily-auto-info-generator'

class InfoGeneratorTest < Test::Unit::TestCase

  def test_check_src
    info_generator = InfoGenerator.new
    assert_true(info_generator.is_contents_src_available)
  end
  
  def test_get_contents
    info_generator = InfoGenerator.new
    contents = info_generator.get_date + info_generator.get_weather + info_generator.get_news
    assert_not_empty(contents)
    puts contents
  end

end