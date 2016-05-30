class WindowLogger
    def log
      require_relative 'do_log'

      worklog_file = "C:\\Users\\poksi\\workspace\\worklog.log"
      dropbox_dir = "C:\\Users\\poksi\\Dropbox\\Log\\"

      dropbox_sync(worklog_file, dropbox_dir, 't1125m')

      File.open(worklog_file, 'a+') do |f|
        f.puts do_log
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
      File.open('~/workspace/worklog.log', 'a+') do |f|
        f.puts `osascript ~/workspace/log-me/worklog/do_log.osa`
      end
    end
  end

end

#def check_login
#  login_cnt = `uptime | grep -E -o "[0-9]+ users" | awk '{print $1}'`
#  return false if login_cnt.eql? "0\n"
#  
#  sleep_state = `/usr/sbin/ioreg -n IODisplayWrangler | grep -o \\"CurrentPowerState\\"=4`
#  return false if sleep_state.empty?
#
#  return true
#end

if __FILE__ == $0
  logger = WindowLogger.new
  logger.log
end
