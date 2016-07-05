# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'digest'

def report_tagger(config_filename)
  cnt = 0
  parent_dir = '/loading/from/config/'
#  Dir.glob(parent_dir + '**/*', File::FNM_DOTMATCH) do |f|
  Dir.glob(parent_dir + '**/*') do |f|
    next unless File.file?(f)
    puts f.gsub(parent_dir, '')
    puts Digest::MD5.file(f).hexdigest
    cnt += 1
  end
  puts "total files : #{cnt}"
end

def compare_result(result_0, result_1)
end

# file-tagger
#  - default config reporting
# file-tagger config-name
# file-tagger compare result1 result2

if __FILE__ == $0

  valid_argv = true
  report_mode = true
  config_file = "file-tagger-config.yml"
  if ARGV.length == 1
    config_file = ARGV[0]
  elsif RGV.length == 3
    valid_argv = false unless ARGV[0] == "compare"
    result_0 = ARGV[1]
    result_1 = ARGV[2]
  else
    valid_argv = false
  end
  
  unless valid_argv
    puts "ruby file-tagger"
    puts "ruby file-tagger config-file.yml"
    puts "ruby file-tagger compare result-file-0.yml result-file-1.yml"
    return
  end
  
  if report_mode
    report_tagger(config_file)
  else
    compare_result(result_0, result_1)
  end

end
