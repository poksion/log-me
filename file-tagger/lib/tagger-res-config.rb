# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'yaml'

class TaggerResConfig
  
  attr_reader :parent_path, :tagger_id, :src_root_path,
   :src_use_multiple_result, :src_multiple_result_type, :src_paging_item_count,
   :src_hash_limit,
   :src_use_file_full_path
  
  def initialize(config_filename)
    
    @parent_path = File.dirname(File.dirname(__FILE__))

    if config_filename == nil or config_filename.empty?
      config_filename = File.join(@parent_path, 'file-tagger-config.yml')
    end

    config_file_path = File.expand_path(config_filename)
    contents = YAML.load_file(config_file_path)
    root = contents['file_tagger_config']
    src = root['src']
      
    @tagger_id = root['tagger_id']
    
    @src_root_path = File.expand_path(src['root_path']) + '/'

    @src_use_multiple_result = src['use_multiple_result']
    @src_multiple_result_type = src['multiple_result_type']
    @src_paging_item_count = src['paging_item_count']
    
    @src_hash_limit = src['hash_limit']
    
    @src_use_file_full_path = src['use_file_full_path']
  end
  
  def get_result_file_full_path(result_file)
    File.expand_path( File.join(@parent_path, 'result', result_file) )
  end

end
