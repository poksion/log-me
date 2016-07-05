# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'yaml'
require 'digest'

class TaggerReporter
  
  def initialize(config_filename)
    file = File.expand_path(config_filename)
    contents = YAML.load_file(config_file_path)
    root = contents['file_tagger_config']

    @tagger_id = root['tagger_id']
    
    src = root['src']
    @src_root_path = File.expand_path(src['root_path'])

  end
  
  def report()
    cnt = 0
    Dir.glob(@src_root_path + '**/*') do |f|
      next unless File.file?(f)
      puts f.gsub(@src_root_path, '')
      puts Digest::MD5.file(f).hexdigest
      cnt += 1
    end
  puts "total files : #{cnt}"
  end

end
