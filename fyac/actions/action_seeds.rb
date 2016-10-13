# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'action'

class SeedsAction < Action

  def content
    text = <<-TEXT
        <html>
        </html>
    TEXT
    return text
  end

  def act(query_string)
    log(CGI::unescape(query_string), :seeds)
  end

end
