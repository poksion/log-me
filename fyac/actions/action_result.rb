# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'action'

class ResultAction < Action

  def content
    text = <<-TEXT
        <html>
          <head>
            <META http-equiv="refresh" content="0;URL=/result/result.html">
          </head>
        </html>
    TEXT
    return text
  end

  def act(empty_query_string)
    query_string = File.read(get_query_result_fullpath())
    query_string.gsub!("\n", "")

    log(query_string, true)
  end

end
