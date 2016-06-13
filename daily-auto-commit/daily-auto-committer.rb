# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'lib/daily-auto-info-generator'
require 'tempfile'

GIT = "/usr/bin/git"
NOTES_DIR = "~/Dropbox/Notes"

def check_committerable
  current_date = Time.new.strftime('%Y-%m-%d')
  last_log_date = `cd #{NOTES_DIR} && #{GIT} log -1 --pretty=format:"%ad" --date=short`
  
  return false if current_date.eql? last_log_date
  
  last_status = `cd #{NOTES_DIR} && #{GIT} status -s`
  if last_status == nil or last_status.empty?
    `echo " * #{current_date}" >> #{NOTES_DIR}/action-information.md`
  end
  
  return true
end

def git_commit(info_generator)
  message = Tempfile.new('daily-aut-commit-message')
  message_path = message.path

  message << info_generator.get_date + info_generator.get_weather + info_generator.get_news
  message.flush
  message.close
  
  `cd #{NOTES_DIR} && #{GIT} add -A && #{GIT} commit -F #{message_path}`
end

def log_copy
    `cp ~/workspace/worklog.log ~/Dropbox/Log/`
    `cp ~/.bash_history ~/Dropbox/Log/bash-history.log`
end

if __FILE__ == $0
  if check_committerable
    info_generator = InfoGenerator.new
    if info_generator.is_contents_src_available
      git_commit(info_generator)
      log_copy
    end
  end
end
