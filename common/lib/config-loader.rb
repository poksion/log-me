require_relative 'os-checker'
require 'yaml'

class ConfigLoader
  include OsChecker
  
  def initialize
    parent_dir = File.dirname(File.dirname(File.dirname(__FILE__)))
    config_file_path = File.join(File.expand_path(parent_dir), 'config.yml')
    contents = YAML.load_file(config_file_path)
    @computer_name = contents['computer_name']
      
    paths = contents['paths']
    @log_dir_fullpath = File.expand_path(paths['log_dir'])
    @log_file_fullpath = File.expand_path(paths['log_file'])
  end
  
  def get_worklog_file_fullpath
    @log_file_fullpath
  end
    
  def get_dropbox_log_dir_fullpath
    @log_dir_fullpath
  end
    
  def get_computer_name
    @computer_name
  end

end