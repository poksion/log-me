# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'lib/path-selector'

def time_generator
  path_selector = PathSelector.new
  t = Time.now
  timestamp = File.join(path_selector.get_project_dirname,"index.timestamp")
  File.open( timestamp, 'w') do |file|
    file.write(t.strftime("%Y%m%d%H%M"))
  end
end

if __FILE__ == $0
  time_generator
end
