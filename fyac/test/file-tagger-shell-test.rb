# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'test/unit'
require_relative '../apis/file-tagger-shell'

class FileTaggerShellTest < Test::Unit::TestCase
  def test_duplicated
    tagger_shell = FileTaggerShell.new("duplicated", "photo-manager-result.yml")
    puts tagger_shell.get_response
  end
end
