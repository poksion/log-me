# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../../config-loader/lib/os-checker'

class PathSelector
  include OsChecker

  def initialize
    if(run_on_mac?)
      @dir_path = File.expand_path("~/blog")
      require 'iconv'
      @utf8Encoder = Iconv.new('UTF-8//IGNORE','UTF-8-MAC')
    else
      @dir_path = File.expand_path('C:\Users\poksi\Dropbox\public\blog')
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
  
  def get_dirname
    @dir_path
  end
end