# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../../common/lib/config-loader'
require_relative '../../common/lib/filename-encoder'

class PathSelector

  def initialize(config_file_name = 'config.yml')
    config_loader = ConfigLoader.new
    @blog_dir_path = config_loader.get_blog_dir_fullpath
    @blog_parent_dir_path = File.dirname(@blog_dir_path)
    
    @filename_encoder = FilenameEncoder.new
  end
  
  def get_filename(md_file)
    @filename_encoder.encode(File.basename(md_file))
  end
  
  def get_blog_dirname
    @blog_dir_path
  end
  
  def get_blog_parent_dirname
    @blog_parent_dir_path
  end

end