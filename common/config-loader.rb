# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'lib/os-checker'
require 'yaml'

class ConfigLoader

  def initialize
    @parent_dir = File.dirname(File.dirname(__FILE__))

    config_file_path = File.join(File.expand_path(@parent_dir), 'config.yml')
    contents = YAML.load_file(config_file_path)

    @computer_name = contents['computer_name']
      
    paths = contents['paths']
    @git_cmd = paths['git']
    @log_dir_fullpath = File.expand_path(paths['log_dir'])
    @log_file_fullpath = File.expand_path(paths['log_file'])
    @blog_dir_fullpath = File.expand_path(paths['blog_dir'])
    @notes_dir_fullpath = File.expand_path(paths['notes_dir'])
    @box_working_dir_fullpath = File.expand_path(paths['box_working_dir'])
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

end

if __FILE__ == $0
  config_loader = ConfigLoader.new

  puts case ARGV[0]
  when 'blog-metadata'
    File.join(config_loader.get_parent_dir_fullpath, "mdblog-metadata-generator/blog-metadata-generator.rb")
  when 'project-metadata'
    File.join(config_loader.get_parent_dir_fullpath, "mdblog-metadata-generator/project-metadata-generator.rb")
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