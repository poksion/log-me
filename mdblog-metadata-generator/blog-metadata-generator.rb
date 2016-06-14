# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'lib/path-selector'

def index_generator

  path_selector = PathSelector.new
  t = Time.now
  timestamp = File.join(path_selector.get_blog_dirname,"index.timestamp")
  File.open( timestamp, 'w') do |file|
    file.write(t.strftime("%Y%m%d%H%M"))
  end
  md = File.join(path_selector.get_blog_dirname,"*.md")

  index_contents = '<?xml version="1.0" encoding="utf-8"?><mds>'
  md_files = Dir.glob(md).sort
  md_files.reverse!
  md_files.each do | md_file |
    tag_attr = ""
    text = File.open( md_file, "r:UTF-8" ) { |f| f.read }
    tag_candi = text.split( "Tag\n====\n" )
    if(tag_candi.size > 1)
      tag_attr = ' tag="' + tag_candi[1] + '"'
    end

    filename = path_selector.get_filename(md_file)
    element = "<md#{tag_attr}>" + filename + "</md>"
    index_contents << element
  end
  index_contents << "</mds>"

  index_file = File.join(path_selector.get_blog_dirname,"index.xml")
  File.open( index_file, 'w') do |file|
    file.write(index_contents)
  end
end

if __FILE__ == $0
  index_generator
end
