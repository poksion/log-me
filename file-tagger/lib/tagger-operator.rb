# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'yaml'

require_relative 'tagger-res-result'

# op_type
# sub : subtraction
# dup : duplication
class TaggerOpSub

  def show(lhs_result, rhs_result)
    
    result = Array.new

    lhs_result.each do | lhs_first_depth |
      lhs_item = lhs_first_depth['item']
      next if  lhs_item == nil
      found_lhs = false
      rhs_result.each do | rhs_first_depth |
        rhs_item = rhs_first_depth['item']
        next if rhs_item == nil
        break if ( found_lhs = (lhs_item[0]['id'] == rhs_item[0]['id']) )
      end
      result << lhs_item[2]['file_full_path'] unless found_lhs
    end
    
    if result.size == 0
      puts "not found"
    else
      result.each do |file_name|
        puts file_name
      end
    end

  end

end

class TaggerOpDup
  def show(report_cols, lhs_result, rhs_result)
    puts "not implemented yet"
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
      col_cnt = 1
      tagger_op = TaggerOpSub.new
    elsif @op_type == 'dup'
      col_cnt = 2
      tagger_op = TaggerOpDup.new
    else
      puts "not impleted op_type : only for 'sub' and 'dup'"
      return
    end

    lhs_result = load_result(@op_lhs)
    rhs_result = load_result(@op_rhs)

    tagger_op.show(lhs_result, rhs_result)
  end

end
