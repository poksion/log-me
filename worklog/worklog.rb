# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end
end

class WindowLogger
  def log
    require_relative 'do_log'
    File.open('C:\Users\poksi\workspace\worklog.log', 'a+') do |f|
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
      File.open('/Users/poksi/workspace/worklog.log', 'a+') do |f|
        f.puts `osascript /Users/poksi/workspace/log-me/worklog/do_log.osa`
      end
    end
  end

end

if __FILE__ == $0

  logger = nil

  if OS.windows?
    logger = WindowLogger.new
  end

  if OS.mac?
    logger = MacLogger.new
  end

  logger.log if logger != nil
end
