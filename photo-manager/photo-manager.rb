# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'digest'

#id: hash-code
# - full_path
# - file_name: (진짜파일이름, 사진/그밑.. 이렇게 나타냄) (태그와 (-_-빼고))
# - tags: (dropbox_2015_-_-file_name.jpg)
# - date:
# - location: 

if __FILE__ == $0
  cnt = 0
  parent_dir = '/your/photo/directory/'
#  Dir.glob(parent_dir + '**/*', File::FNM_DOTMATCH) do |f|
  Dir.glob(parent_dir + '**/*') do |f|
    next unless File.file?(f)
    puts f.gsub(parent_dir, '')
    puts Digest::MD5.file(f).hexdigest
    cnt += 1
  end
  puts "total files : #{cnt}"
end
