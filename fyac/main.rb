require 'sinatra'
require_relative 'actions/action_search'
require_relative 'actions/action_trend'
require_relative 'actions/action_result'
require_relative 'actions/action_newspaper'

def make_action(action_type)
    #trend template
    #http://foundation.zurb.com/templates/marketing.html
    
    if("trend".eql?(action_type))
        return TrendAction.new
    elsif("result".eql?(action_type))
        return ResultAction.new
    elsif("search".eql?(action_type))
        return SearchAction.new
    elsif("newspaper".eql?(action_type))
        return NewspaperAction.new
    else
        return SearchAction.new
    end
end

#Encoding.default_external = Encoding::UTF_8
#Encoding.default_internal = Encoding::UTF_8
#  
#cgi = CGI.new
#
#action = make_action(cgi["a"])
#action.act(cgi["q"])
#
#puts cgi.header
#puts action.content

#set :port, 9494

get '/' do
  'fyac on sinatra'
end
