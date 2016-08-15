# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'yaml'

require_relative 'tagger-res-result'

# op_type
# sub : subtraction
# dup : duplication
class TaggerOpBase

  def show(lhs_result, rhs_result)
    on_begin
    
    lhs_result.each do | lhs_first_depth |
      lhs_item = lhs_first_depth['item']
      next if  lhs_item == nil
      breaked_rhs_item = nil
      rhs_result.each do | rhs_first_depth |
        rhs_item = rhs_first_depth['item']
        next if rhs_item == nil
        breaked_rhs_item = on_compare_item_and_break_if(lhs_item, rhs_item)
        break if breaked_rhs_item != nil
      end

      on_lhs_loop_end(lhs_item, breaked_rhs_item)
    end
    
    on_end
  end
  
  def on_begin
  end
  
  def on_compare_item_and_break_if(lhs_item, rhs_item)
    return nil
  end
  
  def on_lhs_loop_end(lhs_item, breaked_rhs_item)
  end
  
  def on_end
  end

end
  
class TaggerOpSub < TaggerOpBase
  
  def on_begin
    @result = Array.new
  end

  def on_compare_item_and_break_if(lhs_item, rhs_item)
    return lhs_item[0]['id'] == rhs_item[0]['id'] ? rhs_item : nil
  end

  def on_lhs_loop_end(lhs_item, breaked_rhs_item)
    if breaked_rhs_item == nil
      @result << lhs_item[2]['file_full_path']
    end
  end
  
  def on_end
    if @result.size == 0
      puts "not found"
    else
      @result.each do |file_name|
        puts file_name
      end
    end
  end

end

class TaggerOpDup < TaggerOpBase
  def on_begin
    @result = Array.new(2) { Array.new }
  end

  def on_compare_item_and_break_if(lhs_item, rhs_item)
    if lhs_item[0]['id'] == rhs_item[0]['id']
      @result[0] << lhs_item[2]['file_full_path']
      @result[1] << rhs_item[2]['file_full_path']
    end
    # non-break
    return nil
  end
  
  def on_end
    total_cnt = @result[0].size
    if total_cnt == 0
      puts "not found"
    else
      (1..total_cnt).each do |i|
        puts "#{@result[0][i-1]}  -  #{@result[1][i-1]}"
      end
    end
  end

end

class TaggerOpDupSummary < TaggerOpBase
  
  def initialize(op_lhs_name)
    @saved_name = op_lhs_name.gsub(".yml", "-summary.yml")
  end

  def on_begin
    @duplicate_files = Array.new
    @duplicate_full_path = Array.new
  end

  def on_compare_item_and_break_if(lhs_item, rhs_item)
    if lhs_item[0]['id'] == rhs_item[0]['id']
      @duplicate_files << [ lhs_item[1]['file_name'], rhs_item[1]['file_name'] ]
      @duplicate_full_path << [ lhs_item[2]['file_full_path'], rhs_item[2]['file_full_path'] ]
    end
    # non-break
    return nil
  end

  def on_end
    tagger_res_result = TaggerResResult.new
    summary_file_name = tagger_res_result.get_result_file_full_path(@saved_name)
    File.open(summary_file_name, 'w+') do |f|
      tagger_res_result.write_summary_wtih_duplicates(f, @duplicate_files, @duplicate_full_path)
    end
  end

end

class TaggerOperator
  
  def initialize(op_type, op_lhs, op_rhs)
    @op_type = op_type
    @op_lhs = op_lhs
    @op_rhs = op_rhs

    @tagger_res_result = TaggerResResult.new
  end
  
  def load_result(op_hs)
    full_path = @tagger_res_result.get_result_file_full_path(op_hs)
    result = @tagger_res_result.load_result(full_path)
    if result == nil
      puts "no result with : " + full_path
    end
    return result
  end
  
  def show_result
    if @op_type == 'sub'
      tagger_op = TaggerOpSub.new
    elsif @op_type == 'dup'
      tagger_op = TaggerOpDup.new
    elsif @op_type == 'dup-summary'
      tagger_op = TaggerOpDupSummary.new(@op_lhs)
    else
      puts "not impleted op_type : only for 'sub', 'dup' and 'dup-summary'"
      return
    end

    lhs_result = load_result(@op_lhs)
    rhs_result = load_result(@op_rhs)

    tagger_op.show(lhs_result, rhs_result)
  end

end
