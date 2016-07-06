# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'yaml'
require 'digest'

require_relative '../../common/lib/filename-encoder'

class TaggerReporter
  
  def initialize(config_filename)
    
    @filename_encoder = FilenameEncoder.new
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
  
  def get_tagger_id_result
    "#{@tagger_id}-result.yml"
  end
  
  def get_result_map
    result_map = Hash.new
    unless @src_use_multiple_result
      result_map[get_tagger_id_result] = @src_root_path + "**/*"
      return result_map
    end
    
    # directory
    if @src_multiple_result_type == 'directory'
      Dir.glob(@src_root_path + '*/') do |f|
        next unless File.directory?(f)
        result_name = f.gsub(@src_root_path, '')[0...-1] + "-result.yml"
        result_glob = f + "**/*"
        result_map[result_name] = result_glob
      end
      return result_map
    end
    
    # paging
    if @src_multiple_result_type == 'paging'
    end
    
    return result_map
  end
  
  def get_id(f)
    limit_size = @src_hash_limit[0...-2].to_i * 1000 * 1000
    if File.stat(f).size > limit_size
      md5 = Digest::MD5.new
      return md5.update(f).hexdigest + "_name"
    end
    
    return Digest::MD5.file(f).hexdigest
  end
  
  def get_file_name(f)
    @filename_encoder.encode( f.gsub(@src_root_path, '') )
  end
  
  def get_tags(f)
    tags = get_file_name(f).split('/')
    return tags.first(tags.size-1).join(", ")
  end
  
  def check_duplicated_and_append(item, id_group, duplicated_item_ids)
      item_id = item['id']
      group_cnt = id_group[item_id].size
      if group_cnt > 1
        duplicated_item_ids << item_id
        return true
      end
      
      return false
  end
  
  def write_item(f, item)
    f.puts "---"
    f.puts "id : '#{item['id']}'"
    f.puts "  - file_name : '#{item['file_name']}'"
    f.puts "  - file_full_path : '#{item['file_full_path']}'" if @src_use_file_full_path
    f.puts "  - tags : '#{item['tags']}'"
  end
  
  def write_result(result_name, result)
    org_cnt = result.size
    
    id_group = Hash.new { |hash,key| hash[key] = [] }
    result.each { |a| id_group[ a['id'] ] << a }

    duplicated_item_ids = Array.new
    result.delete_if { |i| check_duplicated_and_append(i, id_group, duplicated_item_ids) }
    result.sort! {|a, b| a['file_name'] <=> b['file_name']}

    result_file_fullpath = File.expand_path( File.join(@parent_path, 'result', result_name) )

    File.open(result_file_fullpath, 'w+') do |f|
      f.puts "total : #{org_cnt}"
      f.puts "  item_per_page : #{org_cnt}"
      f.puts "  uniq_files : #{result.size}"
      f.puts "  expected_duplications : #{duplicated_item_ids.size}"
      
      duplicated_item_ids.uniq!
      duplicated_item_ids.each do |id|
        candidate = id_group[id]
        only_file_name = Array.new
        candidate.each { |a| only_file_name << a['file_name'] }
        f.puts "    - candidate : '#{only_file_name.join(', ')}'"
      end

      duplicated_item_ids.each do |id|
        candidate = id_group[id]
        candidate.each { | item | write_item(f, item) }
      end

      result.each { | item | write_item(f, item) }
    end
    
    return org_cnt

  end
  
  def make_result(result_glob)
    result = Array.new

    Dir.glob(result_glob) do |f|
      next unless File.file?(f)
      result_item = Hash.new
      result_item['id'] = get_id(f)
      result_item['file_name'] = get_file_name(f)
      result_item['file_full_path'] = @filename_encoder.encode(f)
      result_item['tags'] = get_tags(f)
      result << result_item
    end
    
    return result
  end
  
  def write_result_info(result_info)
    all_results = 0
    result_info.each { |key, value| all_results += value }

    result_file_fullpath = File.expand_path( File.join(@parent_path, 'result', get_tagger_id_result) )
    File.open(result_file_fullpath, 'w+') do |f|
      f.puts "all_results : #{all_results}"
      result_info.each do |key, value|
        f.puts "  result_file:"
        f.puts "    - file_name : '#{key}'"
        f.puts "    - item_count : #{value}"
      end
    end

  end
  
  def report()
    
    result_map = get_result_map
    
    if result_map.size == 1 and result_map.keys[0] == get_tagger_id_result
        write_result(result_map.keys[0], make_result(result_map.values[0]))
    else
      result_info = Hash.new
      result_map.each do | result_name, result_glob|
        result = make_result(result_glob)
        cnt =  write_result(result_name, result)
        result_info[get_file_name(result_name)] = cnt
      end
      write_result_info(result_info)

    end
  end

end
