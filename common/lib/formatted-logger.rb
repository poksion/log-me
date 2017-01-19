# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'os-checker'
require_relative 'config-loader'

# type of log : print, work, search, result

class WindowLogger
  def log_work
    require_relative 'do_log_win'

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
    require_relative 'do_log_win'
    
    do_logger = WindowDoLogger.new
    puts do_logger.do_log_work
  end
  
  def log(log_value, log_type)
    if (log_type == :search)
      log_search_result(log_value, "")
    elsif (log_type == :result)
      log_search_result(log_value, " _[result_action]_")
    else
      puts "not implemented"
    end
  end
  
  def log_search_result(query_word, result)
    require_relative 'do_log_win'
    
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
    File.join(File.dirname(File.expand_path(__FILE__)), 'do_log_mac.scpt')
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

  def log(log_value, log_type)
    if (log_type == :search or log_type == :result)

      config_loader = ConfigLoader.new
      File.open(config_loader.get_searchlog_file_fullpath, 'a+') do |f|
        if (log_type == :search)
          f.puts `osascript #{get_apple_script_fullpath} "search" "#{log_value}"`
        else
          f.puts `osascript #{get_apple_script_fullpath} "result" "#{log_value}"`
        end
      end

    elsif (log_type == :seeds)
      config_loader = ConfigLoader.new
      File.open(config_loader.get_seedslog_file_fullpath, 'a+') do |f|
        f.puts `osascript #{get_apple_script_fullpath} "seeds" "#{log_value}"`
      end
    else
      puts "not implemented"
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