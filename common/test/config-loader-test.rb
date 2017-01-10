# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'test/unit'
require_relative '../lib/config-loader'

class ConfigLoaderTest < Test::Unit::TestCase

  def test_full_path
    config_loader = ConfigLoader.new
    assert_not_nil(config_loader)
    
    puts config_loader.get_worklog_file_fullpath
    puts config_loader.get_dropbox_log_dir_fullpath
  end
  
  def test_computer_name
    config_loader = ConfigLoader.new('config.template.yml')
    assert_equal('mac', config_loader.get_computer_name)
  end

  def test_port
    config_loader = ConfigLoader.new('config.template.yml')
    # server port are related in fyac / extern-apps / chrome-menu-result / manifest.json
    assert_equal(9494, config_loader.get_server_port)
  end

end