#!/usr/bin/ruby
require_relative 'lib/dev-sync-manager'

# options
# report nas(optional)
# sync file_name

def display_help
    puts "Dev Sync : report or sync your development files"
    puts "    report nas_directory(optional)"
    puts "    sync reported_file_name"
end

if __FILE__ == $0
    proc_done = false
    option_length = ARGV.length
    if option_length == 1
        if ARGV[0] == 'report'
            dev_sync_manager = DevSyncManager.new
            dev_sync_manager.report
            proc_done = true
        end
    end

    if option_length == 2
        if ARGV[0] == 'report'
            dev_sync_manager = DevSyncManager.new
            dev_sync_manager.report( ARGV[1] )
            proc_done = true
        end
        
        if ARGV[0] == 'sync'
            dev_sync_manager = DevSyncManager.new
            dev_sync_manager.sync( ARGV[1] )
            proc_done = true
        end
    end

    unless proc_done
        display_help
    end
end
