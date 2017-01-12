# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'test/unit'
require_relative '../apps/file-tagger-shell-api'

class FileTaggerShellApiTest < Test::Unit::TestCase
  def test_duplicated
    tagger_shell = FileTaggerShellApi.new("duplicated", "mac:result-photo-shared.yml")
    puts tagger_shell.get_response
  end
end
