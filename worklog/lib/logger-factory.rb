# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../../config-loader/lib/os-checker'

class WindowLogger
  def log
    require_relative 'do_log_win'

    do_logger = WindowDoLogger.new

    worklog_file = "C:\\Users\\poksi\\workspace\\worklog.log"
    dropbox_dir = "C:\\Users\\poksi\\Dropbox\\Log\\"

    do_logger.dropbox_sync(worklog_file, dropbox_dir, 't1125m')

    File.open(worklog_file, 'a+') do |f|
      f.puts do_logger.do_log
    end
  end
end

class MacLogger
  def check_login
    login_cnt = `uptime | grep -E -o "[0-9]+ users" | awk '{print $1}'`
    return false if login_cnt.eql? "0\n"

    sleep_state = `/usr/sbin/ioreg -n IODisplayWrangler | grep -o \\"CurrentPowerState\\"=4`
    return false if sleep_state.empty?

    return true
  end

  def log
    if check_login
      File.open('/Users/poksi/workspace/worklog.log', 'a+') do |f|
        f.puts `osascript /Users/poksi/workspace/log-me/worklog/lib/do_log_mac.osa`
      end
    end
  end

end

class LoggerFactory
  extend OsChecker

  def self.newInstance
    if run_on_windows?
        logger = WindowLogger.new
      end
    
      if run_on_mac?
        logger = MacLogger.new
      end

  end
end
