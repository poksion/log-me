# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../../common/lib/config-loader'

if __FILE__ == $0
  config_loader = ConfigLoader.new
  live_config = config_loader.get_raw_paths['live_config']
  if live_config != nil
    `ln -s #{live_config}/vim ~/.vim`
    `ln -s #{live_config}/vimrc ~/.vimrc`
  end

  notes_dir = config_loader.get_raw_paths['notes_dir']
  notes_dir_alias = config_loader.get_raw_paths['notes_dir_alias']
  if notes_dir != nil and notes_dir_alias != nil
    `ln -s #{notes_dir} #{notes_dir_alias}`
  end

  box_working_dir = config_loader.get_raw_paths['box_working_dir']
  box_working_dir_alias = config_loader.get_raw_paths['box_working_dir_alias']
  if box_working_dir != nil and box_working_dir_alias != nil
    `ln -s "#{box_working_dir}" #{box_working_dir_alias}`
  end
end