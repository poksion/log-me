# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'yaml'

class TaggerResConfig
  
  attr_reader :tagger_id,
    :root_path,
    :use_multiple_directories_result,
    :hash_limit,
    :use_file_full_path,
    :exclude_directories
  
  def initialize(config_filename)
    
    parent_path = File.dirname(File.dirname(__FILE__))

    if config_filename == nil or config_filename.empty?
      config_filename = File.join(parent_path, 'config', 'file-tagger-config.yml')
    end

    config_file_path = File.expand_path(config_filename)
    unless File.exist? config_file_path
      config_file_path = File.expand_path( File.join(parent_path, 'config', config_filename) )
    end

    contents = YAML.load_file(config_file_path)
    config = contents['file_tagger_config']

    @tagger_id = config['tagger_id']
    @root_path = File.expand_path(config['root_path']) + '/'

    @use_multiple_directories_result = config['use_multiple_directories_result']
    @hash_limit = config['hash_limit']
    @use_file_full_path = config['use_file_full_path']
    @exclude_directories = config['exclude_directories']
  end

end
