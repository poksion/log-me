# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'test/unit'
require_relative '../lib/tagger-reporter'

class TaggerReporterTest < Test::Unit::TestCase

  def test_tagger_reporter_get_id
    tagger_reporter = TaggerReporter.new("")
    puts tagger_reporter.get_id('/test/with/file.avi')
  end
  
  def test_tagger_reporter_get_file_name
    tagger_reporter = TaggerReporter.new("")
    puts tagger_reporter.get_file_name('/test/with/file.avi')
  end

  def test_tagger_reporter_get_tags
    tagger_reporter = TaggerReporter.new("")
    puts tagger_reporter.get_tags('/test/with/file.avi')
  end

end