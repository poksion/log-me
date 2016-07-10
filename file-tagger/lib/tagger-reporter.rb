# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'yaml'
require 'digest'

require_relative '../../common/lib/filename-encoder'
require_relative 'tagger-res-config'
require_relative 'tagger-res-result'

class TaggerReporter
  
  def initialize(config_filename)
    
    @filename_encoder = FilenameEncoder.new
    @tagger_res_config = TaggerResConfig.new(config_filename)
    @tagger_res_result = TaggerResResult.new
  end
  
  def get_tagger_id_result
    "#{@tagger_res_config.tagger_id}-result.yml"
  end
  
  def get_result_map
    result_map = Hash.new
    unless @tagger_res_config.src_use_multiple_result
      result_map[get_tagger_id_result] = @tagger_res_config.src_root_path + "**/*"
      return result_map
    end
    
    # directory
    if @tagger_res_config.src_multiple_result_type == 'directory'
      Dir.glob(@tagger_res_config.src_root_path + '*/') do |f|
        next unless File.directory?(f)
        result_name = f.gsub(@tagger_res_config.src_root_path, '')[0...-1] + "-result.yml"
        result_glob = f + "**/*"
        result_map[result_name] = result_glob
      end
      return result_map
    end
    
    # paging
    if @tagger_res_config.src_multiple_result_type == 'paging'
    end
    
    return result_map
  end
  
  def get_id(f)
    limit_size = @tagger_res_config.src_hash_limit[0...-2].to_i * 1000 * 1000
    if File.stat(f).size > limit_size
      md5 = Digest::MD5.new
      return md5.update(f).hexdigest + "_name"
    end
    
    return Digest::MD5.file(f).hexdigest
  end
  
  def get_file_size_kb(f)
    file_size_kb = File.stat(f).size / 1000
    file_size_kb = 1 if file_size_kb == 0
    return file_size_kb
  end
  
  def get_formatted_file_size(file_size_kb)
    # GB
    gb_quotient = file_size_kb.fdiv(1000*1000)
    if gb_quotient > 1
      return '%.2fGB' % gb_quotient
    end
    
    mb_quotient = file_size_kb.fdiv(1000)
    return '%.2fMB' % mb_quotient
  end
  
  def get_file_name(f)
    @filename_encoder.encode( f.gsub(@tagger_res_config.src_root_path, '') )
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
  
  def write_result(result_name, result)
    org_cnt = result.size

    total_file_size_kb = 0
    id_group = Hash.new { |hash,key| hash[key] = [] }
    result.each do | item |
      id_group[ item['id'] ] << item
      total_file_size_kb += item['file_size_kb']
    end

    formatted_file_size = get_formatted_file_size(total_file_size_kb)

    duplicated_item_ids = Array.new
    result.delete_if { |i| check_duplicated_and_append(i, id_group, duplicated_item_ids) }
    result.sort! {|a, b| a['file_name'] <=> b['file_name']}

    uniq_cnt = result.size
    duplicated_cnt = duplicated_item_ids.size
    duplicated_item_ids.uniq!
    
    result_file_fullpath = @tagger_res_config.get_result_file_full_path(result_name)

    File.open(result_file_fullpath, 'w+') do |f|
      @tagger_res_result.write_summary(f, org_cnt, formatted_file_size, uniq_cnt, duplicated_cnt, duplicated_item_ids, id_group)

      duplicated_item_ids.each do |id|
        candidate = id_group[id]
        candidate.each { | item | @tagger_res_result.write_item(f, item, @tagger_res_config.src_use_full_path) }
      end

      result.each { | item | @tagger_res_result.write_item(f, item, @tagger_res_config.src_use_full_path) }
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
      result_item['file_size_kb'] = get_file_size_kb(f)
      result_item['file_full_path'] = @filename_encoder.encode(f)
      result_item['tags'] = get_tags(f)
      result << result_item
    end
    
    return result
  end
  
  def write_result_info(result_info)
    result_file_fullpath = @tagger_res_config.get_result_file_full_path(get_tagger_id_result)
    File.open(result_file_fullpath, 'w+') do |f|
      @tagger_res_result.write_all_results_info(f, result_info)
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
