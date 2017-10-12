# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../common/lib/config-loader'

def refine_dir(dir_name)
  File.exists?(dir_name) ? dir_name : ""
end

if __FILE__ == $0
  config_loader = ConfigLoader.new

  puts case ARGV[0]
  when 'blog-metadata'
    File.join(config_loader.get_project_dir_fullpath, "mdblog-metadata-generator", "blog-metadata-generator.rb")
  when 'blog-dir'
    config_loader.get_blog_dir_fullpath
  when 'notes-public-box-dir'
    notes_dir = refine_dir( config_loader.get_notes_dir_fullpath )
    public_dir = refine_dir( File.dirname(config_loader.get_blog_dir_fullpath) )
    box_dir = refine_dir( config_loader.get_box_working_dir_fullpath )
    "#{notes_dir} #{public_dir} #{box_dir}"
  when 'log-ics-dir'
    config_loader.get_log_ics_fullpath
  when 'log-rotator'
    File.join(config_loader.get_project_dir_fullpath, "worklog", "log-rotator.rb")
  else
    'check-parameter : blog-metadata, blog-dir, notes-public-box-dir and log-ics-dir'
  end

end