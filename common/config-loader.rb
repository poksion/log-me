# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'lib/os-checker'
require 'yaml'
require 'uri'

class ConfigLoader

  def initialize
    @parent_dir = File.dirname(File.dirname(__FILE__))

    config_file_path = File.join(File.expand_path(@parent_dir), 'config.yml')
    contents = YAML.load_file(config_file_path)

    @computer_name = contents['computer_name']

    build_path_config(contents['paths'])
    build_server_config(contents['server'])
  end
  
  def build_path_config(paths)
    @git_cmd = paths['git']
    @log_dir_fullpath = File.expand_path(paths['log_dir'])
    @log_file_fullpath = File.expand_path(paths['log_file'])
    @blog_dir_fullpath = File.expand_path(paths['blog_dir'])
    @notes_dir_fullpath = File.expand_path(paths['notes_dir'])
    @box_working_dir_fullpath = File.expand_path(paths['box_working_dir'])
  end
  
  def build_server_config(server_config)
    if (server_config == nil or server_config.empty?)
      @server_port_config = nil
      @search_log_file_fullpath = File.expand_path('~/workspace/search.log')
      @use_on_nas = false
    else
      @server_port_config = File.join(File.expand_path(@parent_dir), server_config['port_config'])
      @search_log_file_fullpath = File.expand_path(server_config['search_log_file'])
      @use_on_nas = server_config['use_on_nas']
    end
  end
  
  def get_parent_dir_fullpath
    @parent_dir
  end

  def get_computer_name
    @computer_name
  end
  
  def get_git_cmd
    @git_cmd
  end
  
  def get_worklog_file_fullpath
    @log_file_fullpath
  end
    
  def get_dropbox_log_dir_fullpath
    @log_dir_fullpath
  end

  def get_blog_dir_fullpath
    @blog_dir_fullpath
  end
  
  def get_notes_dir_fullpath
    @notes_dir_fullpath
  end
  
  def get_box_working_dir_fullpath
    @box_working_dir_fullpath
  end
  
  def get_log_ics_fullpath
    File.join(@log_dir_fullpath, 'backup-calendar')
  end
  
  def get_server_port
    server_port = 9494
    if(@server_port_config != nil)
      port_config_contents = YAML.load_file(@server_port_config)
      permissions = port_config_contents['permissions']
      server_port = URI(permissions[1]).port
    end
    return server_port
  end
  
  def on_nas?
    @use_on_nas
  end
  
  def get_searchlog_file_fullpath
    @search_log_file_fullpath
  end

end

if __FILE__ == $0
  config_loader = ConfigLoader.new

  puts case ARGV[0]
  when 'blog-metadata'
    File.join(config_loader.get_parent_dir_fullpath, "mdblog-metadata-generator/blog-metadata-generator.rb")
  when 'blog-dir'
    config_loader.get_blog_dir_fullpath
  when 'notes-public-box-dir'
    public_dir = File.dirname(config_loader.get_blog_dir_fullpath())
    "#{config_loader.get_notes_dir_fullpath} #{public_dir} #{config_loader.get_box_working_dir_fullpath}"
  when 'log-ics-dir'
    config_loader.get_log_ics_fullpath
  else
    'check-parameter'
  end

end