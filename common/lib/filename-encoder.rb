# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'os-checker'

class FilenameEncoder
  include OsChecker

  def initialize
    if(run_on_mac?)
      require 'iconv'
      @utf8Encoder = Iconv.new('UTF-8//IGNORE','UTF-8-MAC')
    end

  end
  
  def encode(filename)
    if(run_on_mac?)
      encoded_filename = @utf8Encoder.iconv(filename)
    else
      encoded_filename = filename.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "").force_encoding('UTF-8')
    end
    return encoded_filename
  end

end