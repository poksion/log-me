# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'test/unit'
require_relative '../lib/path-selector'

class PathSelectorTest < Test::Unit::TestCase
  def test_path
    path_selector = PathSelector.new
    puts path_selector.get_blog_dirname
    puts path_selector.get_project_dirname
  end
  
end