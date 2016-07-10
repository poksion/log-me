# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'yaml'
require 'digest'

require_relative '../../common/lib/filename-encoder'

class TaggerResResult
  
  def write_item(f, item, use_file_full_path)
    f.puts "---"
    f.puts "item:"
    f.puts "  - id : \"#{item['id']}\""
    f.puts "  - file_name : \"#{item['file_name']}\""
    f.puts "  - file_full_path : \"#{item['file_full_path']}\"" if use_file_full_path
    f.puts "  - tags : \"#{item['tags']}\""
  end
  
  def write_summary(f, org_cnt, formatted_file_size, uniq_cnt, duplicated_cnt, uniq_duplicated_item_ids, id_group)
    f.puts "summary :"
    f.puts "  total : #{org_cnt}"
    f.puts "  size : \"#{formatted_file_size}\""
    f.puts "  uniq_files : #{uniq_cnt}"
    f.puts "  expected_duplications : #{duplicated_cnt}"

    f.puts "  duplication_candidates :"
    uniq_duplicated_item_ids.each do |id|
      candidate = id_group[id]
      only_file_name = Array.new
      candidate.each { |a| only_file_name << a['file_name'] }
      f.puts "    - candidate : \"#{only_file_name.join(', ')}\""
    end
  end
  
  def write_all_results_info(f, result_info)
    all_results = 0
    result_info.each { |key, value| all_results += value }

    f.puts "all_results :"
    f.puts "  total_item_count : #{all_results}"

    result_info.each do |key, value|
      f.puts "---"
      f.puts "  result_file:"
      f.puts "    - file_name : \"#{key}\""
      f.puts "    - item_count : #{value}"
    end
  end
  
  def load_result(result_file_full_path)
    YAML.load_file(result_file_full_path)
  end
  
  def getDuplicated(result)
    candidates = result['summary']['duplication_candidates']
    duplicated = Array.new
    candidates.each { |i| duplicated << "\"#{i['candidate']}\"" }
    "{ \"duplicated\" : [ #{duplicated.join(', ')} ] }"
  end

end
