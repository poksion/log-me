require 'test/unit'
require_relative '../lib/dev-sync-target'

class DevSyncTargetTest < Test::Unit::TestCase
  
  def test_target_bin
    target = DevSyncTarget.new
    assert_not_nil(target.repositories['bin'])
  end
  
end