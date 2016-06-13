require_relative 'lib/os-checker'
require 'yaml'

class ConfigLoader
  include OsChecker
  
  def initialize
    parent_dir = File.dirname File.dirname(__FILE__)
    @config_file_path = File.join(File.expand_path(parent_dir), 'config.yml')
  end
  
  def load
    puts @config_file_path
    contents = YAML.load_file(@config_file_path)
    puts contents.inspect
  end
end