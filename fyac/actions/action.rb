# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../../common/lib/formatted-logger'

FOUNDATION = "/foundation"

class Action

  def content
    return ""
  end

  def act(query_string)
  end
  
  def log(log_value, log_type)
    logger = LoggerFactory.newInstance()
    logger.log(log_value, log_type)
  end

  def get_query_result_fullpath
    return File.join(File.dirname(File.dirname(__FILE__)), 'public/result/query.txt')
  end

end
