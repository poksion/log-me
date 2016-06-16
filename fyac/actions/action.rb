# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../../common/logger-factory'

FOUNDATION = "/foundation"

class Action

  def content
    return ""
  end

  def act(query_string)
  end
  
  def log(query_string, is_result_action)
    logger = LoggerFactory.newInstance()
    if(is_result_action)
      logger.log_result(query_string)
    else
      logger.log_search(query_string)
    end
  end

  def get_query_result_fullpath
    return File.join(File.dirname(File.dirname(__FILE__)), 'public/result/query.txt')
  end

end
