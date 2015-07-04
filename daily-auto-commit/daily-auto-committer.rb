require_relative 'daily-auto-info-generator'
require 'tempfile'

GIT = "/usr/bin/git"
NOTES_DIR = "~/notes"

def check_committerable
  current_date = Time.new.strftime('%Y-%m-%d')
  last_log_date = `cd #{NOTES_DIR} && #{GIT} log -1 --pretty=format:"%ad" --date=short`
  
  return false if current_date.eql? last_log_date
  
  last_status = `cd #{NOTES_DIR} && #{GIT} status -s`
  if last_status == nil or last_status.empty?
    `echo " * #{current_date}" >> #{NOTES_DIR}/no-action-days.md`
  end
  
  return true
end

def git_commit
  message = Tempfile.new('daily-aut-commit-message')
  message_path = message.path

  message << get_date()+get_weather()+get_news()
  message.flush
  message.close
  
  `cd #{NOTES_DIR} && #{GIT} add -A && #{GIT} commit -F #{message_path}`
end

def log_copy
    `cp /Library/WebServer/Documents/log/* ~/Dropbox/Log/`
end

if __FILE__ == $0
  if check_committerable
    if check_connection
      git_commit
      log_copy
    end
  end
end
