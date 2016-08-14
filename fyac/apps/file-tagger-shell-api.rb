# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../../file-tagger/lib/tagger-res-result'

class FileTaggerShellApi
  def initialize(action, file)
    @action = action
    @file = file
    
    fyac_path = File.dirname(File.dirname(__FILE__))
    log_me_path = File.dirname(fyac_path)
    @tagger_res_result = TaggerResResult.new
  end

  def get_response()
    result_file = @tagger_res_result.get_result_file_full_path(@file)
    result = @tagger_res_result.load_result(result_file)
    
    @tagger_res_result.get_duplicated_as_json(result)
  end

end
