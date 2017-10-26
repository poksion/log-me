# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'os-checker'
require 'yaml'
require 'uri'

class ConfigLoader

  def initialize(config_file_name = 'config.yml')
    # lib -> common -> project directory
    @project_dir = File.dirname( File.dirname(File.dirname(File.expand_path(__FILE__))) )

    config_file_path = File.join(@project_dir, config_file_name)
    contents = YAML.load_file(config_file_path)

    @computer_name = contents['computer_name']

    build_path_config(contents['paths'])
    build_server_config(contents['server'])
    build_file_tagger_config(contents['file_tagger'])
  end
  
  def build_path_config(paths)
    @raw_paths = paths
    @git_cmd = paths['git']
    @log_dir_fullpath = get_expand_path_or_empty(paths, 'log_dir', true)
    @log_file_fullpath = get_expand_path_or_empty(paths, 'log_file', true)
    @blog_dir_fullpath = get_expand_path_or_empty(paths, 'blog_dir', true)
    @notes_dir_fullpath = get_expand_path_or_empty(paths, 'notes_dir', true)
    @box_working_dir_fullpath = get_expand_path_or_empty(paths, 'box_working_dir', true)
  end
  
  def build_server_config(server_config)
    @server_port_config = get_join_path_or_nil(server_config, 'port_config', false)
    @search_log_file_fullpath = get_expand_path_or_empty(server_config, 'search_log_file', false)
    @seeds_log_file_fullpath = get_expand_path_or_empty(server_config, 'seeds_log_file', false)
    @use_on_nas = get_boolean_or_false(server_config, 'use_on_nas', false)
  end
  
  def build_file_tagger_config(file_tagger_config)
    @cloud_dir = get_expand_path_or_empty(file_tagger_config, 'cloud_dir', false)
    @nas_dir = get_expand_path_or_empty(file_tagger_config, 'nas_dir', false)
  end
  
  def get_config_map_value(config_map, config_key, check_validation)
    value = config_map == nil ? nil : config_map[config_key]
    if check_validation and value == nil
      puts "invalid config-map for key : #{config_key}"
    end
    value
  end
  
  def get_expand_path_or_empty(config_map, config_key, check_validation)
    value = get_config_map_value(config_map, config_key, check_validation)
    return "" if value == nil or value.empty?
    File.expand_path(value)
  end
  
  def get_join_path_or_nil(config_map, config_key, check_validation)
    value = get_config_map_value(config_map, config_key, check_validation)
    return nil if value == nil or value.empty?
    File.join(@project_dir, value)
  end
  
  def get_boolean_or_false(config_map, config_key, check_validation)
    value = get_config_map_value(config_map, config_key, check_validation)
    return false if value == nil
    value
  end
  
  def get_raw_paths
    if @raw_paths == nil
      @raw_paths = []
    end
    @raw_paths
  end
  
  def get_project_dir_fullpath
    @project_dir
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

  def get_seedslog_file_fullpath
    @seeds_log_file_fullpath
  end
  
  def get_file_tagger_cloud_dir_fullpath
    @cloud_dir
  end

  def get_file_tagger_nas_dir_fullpath
    @nas_dir
  end

end