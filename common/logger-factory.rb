# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'lib/os-checker'
require_relative 'config-loader'

# type of log : print, work, search, result

class WindowLogger
  def log_work
    require_relative 'lib/do_log_win'

    config_loader = ConfigLoader.new
    do_logger = WindowDoLogger.new

    worklog_file = config_loader.get_worklog_file_fullpath
    dropbox_dir = config_loader.get_dropbox_log_dir_fullpath
    comp_name = config_loader.get_computer_name

    do_logger.dropbox_sync(worklog_file, dropbox_dir, comp_name)

    File.open(worklog_file, 'a+') do |f|
      f.puts do_logger.do_log_work
    end
  end
  
  def log_print
    require_relative 'lib/do_log_win'
    
    do_logger = WindowDoLogger.new
    puts do_logger.do_log_work
  end
  
  def log_search(query_word)
    log_search_result(query_word, "")
  end

  def log_result(query_word)
    log_search_result(query_word, " _[result_action]_")
  end
  
  def log_search_result(query_word, result)
    require_relative 'lib/do_log_win'
    
    config_loader = ConfigLoader.new
    do_logger = WindowDoLogger.new
    File.open(config_loader.get_searchlog_file_fullpath, 'a+') do |f|
      f.puts do_logger.do_log_search(query_word, result)
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
  
  def get_apple_script_fullpath
    File.join(File.expand_path(File.dirname(__FILE__)), 'lib/do_log_mac.scpt')
  end

  def log_work
    if check_login
      config_loader = ConfigLoader.new
      worklog_file = config_loader.get_worklog_file_fullpath
      File.open(worklog_file, 'a+') do |f|
        f.puts `osascript #{get_apple_script_fullpath} "work"`
      end
    end
  end
  
  def log_print
    puts `osascript #{get_apple_script_fullpath} "work"`
  end

  def log_search(query_word)
    config_loader = ConfigLoader.new
    File.open(config_loader.get_searchlog_file_fullpath, 'a+') do |f|
      f.puts `osascript #{get_apple_script_fullpath} "search" #{query_word}`
    end
  end

  def log_result(query_word)
    config_loader = ConfigLoader.new
    File.open(config_loader.get_searchlog_file_fullpath, 'a+') do |f|
      f.puts `osascript #{get_apple_script_fullpath} "result" #{query_word}`
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
      
      return logger
  end
end

if __FILE__ == $0
  logger = LoggerFactory.newInstance()
  logger.log_print
end