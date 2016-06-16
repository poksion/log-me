# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'lib/daily-auto-info-generator'
require_relative '../common/config-loader'
require 'tempfile'

def check_committerable(notes_dir, git_cmd)
  current_date = Time.new.strftime('%Y-%m-%d')
  last_log_date = `cd #{notes_dir} && #{git_cmd} log -1 --pretty=format:"%ad" --date=short`
  
  return false if current_date.eql? last_log_date
  
  last_status = `cd #{notes_dir} && #{git_cmd} status -s`
  if last_status == nil or last_status.empty?
    `echo " * #{current_date}" >> #{notes_dir}/action-information.md`
  end
  
  return true
end

def git_commit(info_generator, notes_dir, git_cmd)
  message = Tempfile.new('daily-aut-commit-message')
  message_path = message.path

  message << info_generator.get_date + info_generator.get_weather + info_generator.get_news
  message.flush
  message.close
  
  `cd #{notes_dir} && #{git_cmd} add -A && #{git_cmd} commit -F #{message_path}`
end

def log_copy(worklog_file, searchlog_file, save_dir)
    `cp #{worklog_file} #{save_dir}`
    `cp #{searchlog_file} #{save_dir}`

    bash_save_file = File.join(save_dir, 'bash-history.log')
    `cp ~/.bash_history #{bash_save_file}`
end

if __FILE__ == $0
  config_loader = ConfigLoader.new
  notes_dir = config_loader.get_notes_dir_fullpath
  git_cmd = config_loader.get_git_cmd
  
  worklog_file = config_loader.get_worklog_file_fullpath
  searchlog_file = config_loader.get_searchlog_file_fullpath
  log_dir = config_loader.get_dropbox_log_dir_fullpath

  if check_committerable(notes_dir, git_cmd)
    info_generator = InfoGenerator.new
    if info_generator.is_contents_src_available
      git_commit(info_generator, notes_dir, git_cmd)
      log_copy(worklog_file, searchlog_file, log_dir)
    end
  end
end
