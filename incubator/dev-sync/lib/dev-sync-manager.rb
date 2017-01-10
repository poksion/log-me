require_relative 'dev-sync-reporter'
require 'json'
require 'fileutils'

class CopyCommand
    def initialize(src, target_directory)
        @src = src
        @target_directory = target_directory
    end
    
    def act
        unless File.exist? @src
            puts "No src file : #{@src}"
            return
        end

        begin
            FileUtils.mkdir_p(@target_directory) unless File.exist? @target_directory
            FileUtils.cp_r(@src, @target_directory, :verbose=>true)
        rescue Errno::EACCES => e
            # do things for appropriate error handling
            puts e.message
        end
    end
    
    def print
        puts "src : #{@src} & target : #{@target_directory}"
    end
end

class DevSyncManager
    def report(nas_directory = nil)
        reporter = DevSyncReporter.new
        reporter.report(nas_directory)
    end
    
    def sync(sync_list_file)
        path = File.expand_path(sync_list_file)
        unless File.exist? path
            puts "Sync list file does not exist"
        end
        text = File.read(path)
        sync_info = JSON.parse(text)
        nas_directory = sync_info['nas_directory']
        from_nas = sync_info['from_nas']
        to_nas = sync_info['to_nas']

        copy_from_nas(from_nas,nas_directory)
        copy_to_nas(to_nas,nas_directory)
    end
    
    def copy_from_nas(from_nas, nas_directory)
        copy(from_nas, nas_directory, true)
    end

    def copy_to_nas(to_nas, nas_directory)
        copy(to_nas, nas_directory, false)
    end
    
    def copy(nas_info, nas_directory, is_from_nas)
        sync_target = DevSyncTarget.new
        sync_copy_jobs = Array.new

        nas_info.each do |nas_path, nas_items|
            sync_target.repositories.each do |repo_name, repo|
                repo.each do |type, values|
                    values.each do |key_like_nas_path, path_or_items|
                        if key_like_nas_path == nas_path
                            nas_full_path = nas_directory + '/' + nas_path
                            append_copy_jobs(sync_copy_jobs, nas_full_path, nas_items, type, path_or_items, is_from_nas)
                        end
                    end
                end
            end
        end
        
        sync_copy_jobs.each do | command |
            #command.print
            command.act
        end

    end
    
    def append_copy_jobs(copy_jobs, nas_full_path, nas_items, type, path_or_items, is_from_nas)
        if is_from_nas
            target_directory = ''
            if type == :path
                target_directory = path_or_items
            else
                values = path_or_items.split(';')
                target_directory = File.dirname(values[0])
            end

            expand_target = File.expand_path(target_directory)
            nas_items.each do |item|
                src = nas_full_path + '/' + item
                expand_src = File.expand_path(src)
                job = CopyCommand.new(expand_src, expand_target)
                copy_jobs << job
            end
        else
            expand_target = File.expand_path(nas_full_path)
            nas_items.each do |item|
                src = ''
                if type == :path
                    src = path_or_items + '/' + item
                else
                    src = item
                end
                expand_src = File.expand_path(src)
                job = CopyCommand.new(expand_src, expand_target)
                copy_jobs << job
            end
        end
    end
end
