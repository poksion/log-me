# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../common/lib/config-loader'

if __FILE__ == $0
  config_loader = ConfigLoader.new

  puts case ARGV[0]
  when 'blog-metadata'
    File.join(config_loader.get_project_dir_fullpath, "mdblog-metadata-generator/blog-metadata-generator.rb")
  when 'blog-dir'
    config_loader.get_blog_dir_fullpath
  when 'notes-public-box-dir'
    public_dir = File.dirname(config_loader.get_blog_dir_fullpath())
    "#{config_loader.get_notes_dir_fullpath} #{public_dir} #{config_loader.get_box_working_dir_fullpath}"
  when 'log-ics-dir'
    config_loader.get_log_ics_fullpath
  else
    'check-parameter : blog-metadata, blog-dir, notes-public-box-dir and log-ics-dir'
  end

end