# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'Win32API'
require 'win32ole'
require 'socket'
require 'FileUtils'

#-- <format-id> <ip> <ssid> <date> <appname> <window-title>
#"a4 " & theIp & " " & theSsid & " " & theDate & " " & frontApp & ": " & window_title

class WindowDoLogger
  
  @@proc_filter = ['LockApp.exe', 'System Idle Process', 'LockAppHost.exe']
  
  def encoded_str(raw_str)
    raw_str.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "").force_encoding('UTF-8')
  end
  
  def dropbox_sync(worklog_file, dropbox_dir_without_lastslash, machin_name)
    dropbox_file = dropbox_dir_without_lastslash + '/worklog-' + Time.now.strftime("%Y%m%d") + '-' + machin_name + '.log'
    if not File.exist? dropbox_file
      if File.exist? worklog_file
        FileUtils.move worklog_file, dropbox_file
      end
    end
  end

  def do_log_work
    active_window_handle = get_active_window_handle

    proc_name = get_proc_name(active_window_handle)
    return "" if @@proc_filter.include?(proc_name)
    
    title = get_title(active_window_handle)
    
    ssid = get_ssid
    ip_addr = get_ip
    date = get_date
    
    return "a5 #{ip_addr} #{ssid} #{date} #{proc_name}: #{title}"
  end
  
  def do_log_search(query_word, with_result)
    ssid = get_ssid
    ip_addr = get_ip
    date = get_date
    "s1 #{ip_addr} #{ssid} #{date} #{query_word}#{with_result}"
  end

  def get_active_window_handle
    getForegroundWindow = Win32API.new('user32', 'GetForegroundWindow', [], 'N')
    getForegroundWindow.Call
  end

  def get_title(window_handle)
    getWindowTextLength =  Win32API.new('user32', 'GetWindowTextLength', ['L'], 'I')
    buf_len = getWindowTextLength.Call(window_handle)
    title_buf = ' ' * (buf_len+1)
    getWindowText = Win32API.new('user32', 'GetWindowText', ['L', 'P', 'I'], 'I')
    getWindowText.Call(window_handle, title_buf, title_buf.length)
    
    title_buf.gsub(/\000/, '').encode('utf-8', 'euc-kr')
  end

  def get_proc_name(window_handle)
    getWindowThreadProcessId = Win32API.new('user32', 'GetWindowThreadProcessId', ['L', 'P'], 'L')
    pid = [0].pack('L')
    getWindowThreadProcessId.Call(window_handle, pid)
    pid = pid.unpack('L')[0]
    
    get_proc_name_from_pid(pid)
  end

  def get_proc_name_from_pid(pid)
    procs = WIN32OLE.connect("winmgmts:\\\\.")
    procs.InstancesOf("win32_process").each do |p|
      if pid == p.processId
        return p.name
      end
    end
    return "-"
  end

  def get_date
    Time.now.strftime("%Y/%m/%d-%H:%M")
  end

  def get_ssid
    results = encoded_str(`netsh wlan show interfaces`).split( /\r?\n/ )
    results.each do |item|
      if item.include?('SSID')
        return item.sub(/.*SSID.*: /, '')
      end
    end
    return "-"
  end

  def get_ip
    Socket.ip_address_list.each do |ip|
      if ip.ipv4? and not ip.ipv4_loopback?
        return ip.ip_address
      end
    end
    return "-"
  end

end
