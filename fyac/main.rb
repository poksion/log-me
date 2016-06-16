require 'sinatra'
require '../common/config-loader'

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
        return TrendAction.new
    end
end

def get_port
  config_loader = ConfigLoader.new
  return config_loader.get_server_port
end

set :port, get_port

get '/' do
  action = make_action(params["a"])
  action.act(params['q'])

  action.content
  #'fyac on sinatra'
end
