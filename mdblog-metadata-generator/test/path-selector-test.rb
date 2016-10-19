# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'test/unit'
require_relative '../lib/path-selector'

class PathSelectorTest < Test::Unit::TestCase
  def test_path
    path_selector = PathSelector.new('config.template.yml')
    puts path_selector.get_public_dirname
    assert_true(path_selector.get_blog_dirname.include?('/Dropbox/public'))
    assert_true(path_selector.get_blog_dirname.include?('/Dropbox/public/blog'))
  end
  
end