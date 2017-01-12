# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'sinatra'

require_relative '../common/lib/config-loader'

require_relative 'actions/action_search'
require_relative 'actions/action_trend'
require_relative 'actions/action_result'
require_relative 'actions/action_newspaper'
require_relative 'actions/action_seeds'

require_relative 'apps/file-tagger-shell-api'

require_relative 'apps/nas-portal'
require_relative 'apps/file-manager'

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
  elsif("seeds".eql?(action_type))
    return SeedsAction.new
  else
    return TrendAction.new
  end
end

$config_loader = ConfigLoader.new

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

set :port, $config_loader.get_server_port

get '/' do
  return "restricted on nas" if $config_loader.on_nas?
   
  action = make_action(params['a'])
  action.act(params['q'])

  action.content
end

get '/nas-portal' do
  nas_portal = NasPortal.new
  @items = nas_portal.get_items
  erb :nas_portal_view
end

get '/file-tagger-shell-api' do
  file_tagger_shell_api = FileTaggerShellApi.new(params['a'], params['f'])
  file_tagger_shell_api.get_response
end

get '/file-tagger-shell' do
  project_dir = File.dirname(File.expand_path(__FILE__))
  File.read(File.join(project_dir, 'public', 'apps', 'file-tagger-shell.html'))
end

get '/file-manager' do
  file_manager = FileManager.new(params['a'], params['ef'])
  view_file = file_manager.get_response_as_view
  if view_file != nil
    send_file view_file
  end
  file_manager.get_response
end
