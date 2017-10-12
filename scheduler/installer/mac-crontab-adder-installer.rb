# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../agent/mac-agent-adder'

if __FILE__ == $0
  installer = MacInstaller.new
  installer.install('net.poksion.logme.crontab-adder.plist')
end