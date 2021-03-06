# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative '../../common/lib/config-loader'
require_relative '../../common/lib/os-checker'

class OsSpecific
  include OsChecker
  
  def run(live_config)
    if run_on_mac?
      `rm -rf ~/.bash_profile && ln -s #{live_config}/mac-bash-profile ~/.bash_profile`
      `rm -rf ~/.config/karabiner/karabiner.json && ln -s #{live_config}/karabiner.json ~/.config/karabiner/karabiner.json`
      `mkdir ~/Library/KeyBindings/`
      `rm -rf ~/Library/KeyBindings/DefaultKeyBinding.dict && ln -s #{live_config}/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict`
    end
  end
  
  def install_box_path(box_working_dir, box_working_dir_alias)
    if run_on_linux? == false and box_working_dir != nil and box_working_dir_alias != nil
      `rm -rf #{box_working_dir_alias} && ln -s "#{File.expand_path(box_working_dir)}" #{box_working_dir_alias}`
    end
  end
end

if __FILE__ == $0
  config_loader = ConfigLoader.new
  os_specific = OsSpecific.new

  live_config = config_loader.get_raw_paths['live_config']
  if live_config != nil
    `rm -rf ~/.vim && ln -s #{live_config}/vim ~/.vim`
    `rm -rf ~/.vimrc && ln -s #{live_config}/vimrc ~/.vimrc`
    `mkdir ~/.vim_swap`
    os_specific.run(live_config)
  end

  notes_dir = config_loader.get_raw_paths['notes_dir']
  notes_dir_alias = config_loader.get_raw_paths['notes_dir_alias']
  if notes_dir != nil and notes_dir_alias != nil
    `rm -rf #{notes_dir_alias} && ln -s #{notes_dir} #{notes_dir_alias}`
  end

  box_working_dir = config_loader.get_raw_paths['box_working_dir']
  box_working_dir_alias = config_loader.get_raw_paths['box_working_dir_alias']
  os_specific.install_box_path(box_working_dir, box_working_dir_alias)
end