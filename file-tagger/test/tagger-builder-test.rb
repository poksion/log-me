# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'test/unit'
require_relative '../lib/tagger-builder'

class TaggerBuilderTest < Test::Unit::TestCase

  def test_tagger_builder_get_id
    tagger_builder = TaggerBuilder.new("")
    puts tagger_builder.get_id('/test/with/file.avi', true)
  end
  
  def test_tagger_builder_get_file_name
    tagger_builder = TaggerBuilder.new("")
    puts tagger_builder.get_file_name_from_unencoded('/test/with/file.avi')
  end

  def test_tagger_builder_get_tags
    tagger_builder = TaggerBuilder.new("")
    puts tagger_builder.get_tags_from_unencoded('test/with/file.avi')
  end

end