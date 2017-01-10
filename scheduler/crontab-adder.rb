# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

if __FILE__ == $0
  crontab_list = `crontab -l`
  if crontab_list == nil or not crontab_list.include?("worklog")
    echo_worklog = 'echo "* * * * * /usr/bin/ruby ~/workspace/log-me/worklog/worklog.rb"'
    echo_daily_auto_commit = 'echo "5 6-22 * * * /usr/bin/ruby ~/workspace/log-me/daily-auto-commit/daily-auto-committer.rb"'
    `(crontab -l ; #{echo_worklog} ; #{echo_daily_auto_commit} ) | crontab -`
  end
end