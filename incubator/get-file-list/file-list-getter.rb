#!/usr/bin/ruby
require 'find'

def push_to_result(result, filename, is_only_file_name)
    unless(File.directory?(filename))
        if(is_only_file_name)
            result.push(File.basename(filename))
        else
            result.push(filename)
        end
    end
end

def get_file_list(path, is_only_file_name)

    result = Array.new
    if(File.directory?(path))
        Find.find(path).each do |file|
            push_to_result(result, file, is_only_file_name)
        end
    else
        File.open(path).each do |line|
            push_to_result(result, line, is_only_file_name)
        end
    end
    
    if(is_only_file_name)
        result.sort!
        result.uniq!
    end
    
    result.each do |name|
        puts name
    end
end
