# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'lib/logger-factory'

if __FILE__ == $0
  logger = LoggerFactory.newInstance
  logger.log if logger != nil
end
