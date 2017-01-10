# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

class MacInstaller
  def install(plist_file_name)
    plist_file_local = File.join(File.dirname(File.expand_path(__FILE__)), plist_file_name)
    plist_file_installed = File.join('~/Library/LaunchAgents', plist_file_name)   
    `ln -s #{plist_file_local} #{plist_file_installed}`
  end
end