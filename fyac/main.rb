# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'sinatra'

require_relative '../common/config-loader'

require_relative 'actions/action_search'
require_relative 'actions/action_trend'
require_relative 'actions/action_result'
require_relative 'actions/action_newspaper'

require_relative 'apis/file-tagger-shell'

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

$config_loader = ConfigLoader.new

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

set :port, $config_loader.get_server_port
set :public_folder, 'nas-public' if $config_loader.on_nas?

get '/' do
  return "restricted on nas" if $config_loader.on_nas?
   
  action = make_action(params['a'])
  action.act(params['q'])

  action.content
end

get '/apis/file-tagger-shell' do
  return "restricted on nas" if $config_loader.on_nas?

  fileTaggerShell = FileTaggerShell.new(params['a'], params['f'])
  fileTaggerShell.get_response
end