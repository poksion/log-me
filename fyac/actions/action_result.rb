# encoding: utf-8

require_relative 'action'

class ResultAction < Action

    def content
        text = <<-TEXT
        <html>
          <head>
            <META http-equiv="refresh" content="0;URL=#{SEARCH_RESULT_HTTP}">
          </head>
        </html>
        TEXT
        return text
    end

    def act(empty_query_string)
        query_string = File.read(QUERY_RESULT)
        query_string.gsub!("\n", "")
        log(query_string, true)
    end
end
