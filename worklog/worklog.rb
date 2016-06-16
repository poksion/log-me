# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../common/logger-factory'

if __FILE__ == $0
  logger = LoggerFactory.newInstance
  logger.log_work if logger != nil
end
