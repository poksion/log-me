# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../../common/lib/os-checker'
require_relative '../../common/config-loader'

class WindowLogger
  def log
    require_relative 'do_log_win'

    config_loader = ConfigLoader.new
    do_logger = WindowDoLogger.new

    worklog_file = config_loader.get_worklog_file_fullpath
    dropbox_dir = config_loader.get_dropbox_log_dir_fullpath
    comp_name = config_loader.get_computer_name

    do_logger.dropbox_sync(worklog_file, dropbox_dir, comp_name)

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
      config_loader = ConfigLoader.new
      worklog_file = config_loader.get_worklog_file_fullpath
      File.open(worklog_file, 'a+') do |f|
        osa_script_fullpath = File.join(File.expand_path(File.dirname(__FILE__)), 'do_log_mac.osa')
        f.puts `osascript #{osa_script_fullpath}`
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
