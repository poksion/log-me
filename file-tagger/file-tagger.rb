# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'digest'

if __FILE__ == $0
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
