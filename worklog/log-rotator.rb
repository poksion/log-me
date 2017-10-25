# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'fileutils'

require_relative '../common/lib/config-loader'
require_relative '../common/lib/file-linereader'

def get_log_dir
  path = "~/workspace/Log"
  return File.expand_path(path)
end

def get_formatted_date_from_log(line)
  line.split(" ")[3].split("-")[0].gsub("/", "")
end

def read_head_tail_and_copy(file_name, file_ext, machine)
  from_file = File.join(get_log_dir, "#{file_name}.#{file_ext}")

  head, tail = read_head_and_tail(from_file)

  start_date = get_formatted_date_from_log(head)
  end_date = get_formatted_date_from_log(tail)
  to_file = File.join(get_log_dir, "backup", "#{file_name}-#{machine}-#{start_date}-#{end_date}.#{file_ext}")
  
  puts to_file
  FileUtils.cp(from_file, to_file)
  FileUtils.rm(from_file)
end

def get_formatted_date_from_file(file_name)
  base_name = File.basename(file_name)
  base_name.split("-")[1]
end

def get_files(file_name, file_ext, machine)
  glob_files = File.join(get_log_dir, "#{file_name}-*-#{machine}.#{file_ext}")
  Dir.glob(glob_files).sort
end

def read_file_and_merge(file_name, file_ext, machine)
  files = get_files(file_name, file_ext, machine)
  start_date = get_formatted_date_from_file(files.first)
  end_date = get_formatted_date_from_file(files.last)
  
  to_file = File.join(get_log_dir, "backup", "#{file_name}-#{machine}-#{start_date}-#{end_date}.#{file_ext}")
  puts to_file
  File.open(to_file, 'w') do |outfile|
    files.each do |file|
      text = File.open(file, 'r').read
      text.each_line do |line|
        line = line.encode('utf-8', 'euc-kr', :invalid=>:replace, :undef=>:replace) unless line.valid_encoding?
        outfile << line.gsub(/\x00/, "")
      end
      FileUtils.rm(file)
    end
  end
end

def read_bash_history_and_merge(machine)
  glob_files = File.join(get_log_dir, "bash-history-*.log")
  files = Dir.glob(glob_files).sort

  start_date = date_raw = File.basename(files.first).split("-")[2].gsub(".log", "")
  end_date = date_raw = File.basename(files.last).split("-")[2].gsub(".log", "")
  to_file = File.join(get_log_dir, "backup", "bash-#{machine}-#{start_date}-#{end_date}.log")
  puts to_file
  
  files_cnt = files.size
  current_idx = 0
  
  File.open(to_file, 'w') do |outfile|
    files_cnt.times do
      file = files[current_idx]
      date_raw = File.basename(file).split("-")[2]
      date = "#{date_raw[0,4]}/#{date_raw[4,2]}/#{date_raw[6,2]}"
      
      current_lines = IO.readlines(file)
      prev_idx = current_idx - 1
      current_idx += 1
      if prev_idx < 0
        prev_lines = []
      else
        prev_lines = IO.readlines(files[prev_idx])
      end
      only_current_lines = current_lines - prev_lines
      only_current_lines.each do |only_current|
        outfile << "b1 #{date} #{only_current}"
      end
    end
  end
  
  files.each do |file|
    FileUtils.rm(file)
  end

end

class BaseLogRotator
  def initialize(machine)
    @machine = machine
  end
end

class BashLogRotator < BaseLogRotator
  def run
    if @machine == "mac"
      read_bash_history_and_merge(@machine)
    else
      puts "Only supprot mac"
    end
  end
end

class SearchLogRotator < BaseLogRotator
  def run
    if @machine == "mac"
      read_head_tail_and_copy("search", "log", @machine)
    else
      puts "Only supprot mac"
    end
  end
  
end

class SeedLogRotator < BaseLogRotator
  def run
    if @machine == "mac"
      read_head_tail_and_copy("seeds", "log", @machine)
    else
      puts "Only supprot mac"
    end
  end
end

class WorkLogRotator < BaseLogRotator
  def run
    if @machine == "mac"
      read_head_tail_and_copy("worklog", "log", @machine)
    else
      read_file_and_merge("worklog", "log", @machine)
    end
  end
end

class UndefinedRotator
  def initialize(logType, machine)
    @logType = logType
    @machine = machine
  end
  
  def run
    puts "#{@logType} with #{@machine} is not supported"
    puts "check : bash, search, seed, work"
  end
end

def logRotatorFactory(logType, machine)
  case logType
  when 'bash'
    rotator = BashLogRotator.new(machine)
  when 'search'
    rotator = SearchLogRotator.new(machine)
  when 'seed'
    rotator = SeedLogRotator.new(machine)
  when 'work'
    rotator = WorkLogRotator.new(machine)
  else
    rotator = UndefinedRotator.new(logType, machine)
  end
  rotator
end

if __FILE__ == $0
  rotator = logRotatorFactory(ARGV[0], ARGV[1])
  rotator.run
end
