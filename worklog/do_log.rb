# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'Win32API'
require 'win32ole'
require 'socket'

def do_log
  active_window_handle = get_active_window_handle

  title = get_title(active_window_handle)
  proc_name = get_proc_name(active_window_handle)
  
  ssid = get_ssid
  ip_addr = get_ip
  date = get_date
  
  "a4 #{ip_addr} #{ssid} #{date} #{proc_name}: #{title}"
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
  
  title_buf
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
  results = `netsh wlan show interfaces`.split( /\r?\n/ )
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

#-- <format-id> <ip> <ssid> <date> <appname> <window-title>
#"a4 " & theIp & " " & theSsid & " " & theDate & " " & frontApp & ": " & window_title
