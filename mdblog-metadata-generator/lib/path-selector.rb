# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../../common/lib/os-checker'
require_relative '../../common/config-loader'

class PathSelector
  include OsChecker

  def initialize
    config_loader = ConfigLoader.new
    @blog_dir_path = config_loader.get_blog_dir_fullpath
    @project_dir_path = File.dirname(@blog_dir_path)

    if(run_on_mac?)
      require 'iconv'
      @utf8Encoder = Iconv.new('UTF-8//IGNORE','UTF-8-MAC')
    end

  end
  
  def get_filename(md_file)
    if(run_on_mac?)
      filename = @utf8Encoder.iconv(File.basename(md_file))
    else
      filename = File.basename(md_file).encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "").force_encoding('UTF-8')
    end
    return filename
  end
  
  def get_blog_dirname
    @blog_dir_path
  end
  
  def get_project_dirname
    @project_dir_path
  end
end