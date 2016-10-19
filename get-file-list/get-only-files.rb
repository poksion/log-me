#!/usr/bin/ruby

require_relative 'file-list-getter'

if __FILE__ == $0
    path = "."
    if(ARGV.size > 0)
        path = ARGV[0]
    end
    get_file_list(path, true)
end
