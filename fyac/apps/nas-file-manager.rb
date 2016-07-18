# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'base64'
require 'cgi'

class NasFileManager

  def initialize(action, encoded_files)
    @action = action
    @encoded_files = encoded_files
  end
  
  def get_img_srcs(files)
    result = ""
    files.each do |file|
      result += ('<img src="/nas-file-manager?a=view&ef=' + CGI::escape(file) + '">')
    end
    return result
  end
  
  def read_img(encoded_file)
    file = CGI::unescape(encoded_file)
    file = File.join(File.dirname(__FILE__), 'nas-file-not-exist.png') unless File.exist? file
    File.read(file)
  end

  def get_response()
    
    if @action == 'view'
      read_img(@encoded_files)
    else
      files = Base64.decode64( @encoded_files ).force_encoding('UTF-8').split(", ")
      result = %{
        <html>
          <body>
            #{get_img_srcs(files)}
          </body>
        </html>
      }
      return result
    end
  end

end
