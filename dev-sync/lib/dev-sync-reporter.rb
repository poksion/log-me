require_relative 'dev-sync-target'

class DevSyncReporter

    def initialize
        @target = DevSyncTarget.new
    end

    def report(nas_directory)
        @result = nil
        @sync_info = nil
        @local_result = nil
        
        repositories = @target.repositories
        only_local = true

        if nas_directory != nil
            only_local = false
            return unless build_sync_info(nas_directory, repositories)
        end

        start_first("local")
        
        repositories.each_with_index do |(name, value), index |
            has_next = true
            if index == repositories.size - 1
                has_next = false
            end
            build_result(value, name, has_next)
        end
        
        if only_local
            end_first(false)
        else
            end_first(true)
            build_result_nas(nas_directory)
        end

        puts @result
    end
    
    def start_first(first_key)
        if(@result == nil)
            @result = "{\n"
        end
        
        @result << "    \"#{first_key}\" : {\n"
    end
    
    def end_first(has_next)
        if(has_next)
            @result << "    },\n\n"
        else
            @result << "    }\n}"
        end
    end
    
    def start_second(second_key)
        @result << "        \"#{second_key}\" : [\n"
    end
    
    def end_second(has_next)
        if(has_next)
            @result << "        ],\n\n"
        else
            @result << "        ]\n"
        end
    end
    
    def append_third(value, has_next)
        if(has_next)
            @result << "            \"#{value}\",\n"
        else
            @result << "            \"#{value}\"\n"
        end
    end
    
    def get_list_from_path(path)
        result = Array.new
        
        expanded = File.expand_path(path)
        if File.exist? expanded
            Dir.foreach( File.expand_path(path) ) do |item|
              next if item == '.' or item == '..'
              result << item
            end
        end
        
        return result
    end

    def get_list_from_item(item)
        result = Array.new
        
        values = item.split(";")
        values.each do |value|
            stripped = value.strip
            if stripped.length != 0 and File.exist?(File.expand_path(stripped))
                result << stripped
            end
        end
        return result
    end
    
    def add_local_result(repository_name, category_name, result) 
        if(@local_result == nil)
            @local_result = Hash.new
        end
        
        if(@local_result[repository_name] == nil)
            @local_result[repository_name] = Hash.new
        end

        @local_result[repository_name][category_name] = result
    end
    
    def build_result_second(repository_name, key, value, has_next)
        if(key == :path)
            value.each do |path_key, path_value|
                start_second(path_key)
                result = get_list_from_path(path_value)
                result.each_with_index do |item, index|
                    if(index == result.size - 1)
                        append_third(item, false)
                    else
                        append_third(item, true)
                    end
                end
                add_local_result(repository_name, path_key, result)

                end_second(has_next)
            end
        else
            value.each do |item_key, item_value|
                start_second(item_key)
                result = get_list_from_item(item_value)
                result.each_with_index do |item, index|
                    if(index == result.size - 1)
                        append_third(item, false)
                    else
                        append_third(item, true)
                    end
                end
                add_local_result(repository_name, item_key, result)
                
                end_second(has_next)
            end
        end
    end
    
    def build_result(repository, name, force_has_next)
        repository.each_with_index do |(key, value), key_idx|
            has_next = true
            if(key_idx == repository.size - 1)
                has_next = false
            end
            if(force_has_next)
                has_next = true
            end
            build_result_second(name, key,value,has_next)
        end
    end
    
    def build_sync_info(nas_directory, repositories)
        nas_path = File.expand_path(nas_directory)
        unless File.exist? nas_path
            puts "NAS directory is invalid"
            return false
        end
        @sync_info = Hash.new
        repositories.each do |repo_name, repo|
            @sync_info[repo_name] = Array.new
            repo.each do |item_type, category_key_value|
                category_key_value.each do |key, value|
                    @sync_info[repo_name] << key
                end
            end
        end
        return true
    end

    def build_result_nas(nas_directory)
        only_local = Hash.new
        only_nas = Hash.new

        @sync_info.each do |repo_name, categories|
            only_local[repo_name] = Hash.new
            only_nas[repo_name] = Hash.new

            categories.each do |category|
                local_items = @local_result[repo_name][category]

                path = File.expand_path(nas_directory + '/' + category)
                nas_items = get_list_from_path(path)
                
                #only local
                only_local_repo_category = Array.new
                local_items.each do | item |
                    local_item_basename = File.basename(item)
                    unless nas_items.include? local_item_basename
                        only_local_repo_category << item
                    end
                end
                only_local[repo_name][category] = only_local_repo_category

                #only nas
                only_nas_repo_category = Array.new
                nas_items.each do | item |
                    is_included = false
                    local_items.each do | local_item |
                        local_item_basename = File.basename(local_item)
                        is_included = true if local_item_basename == item
                    end
                    unless is_included
                        only_nas_repo_category << item
                    end
                end
                only_nas[repo_name][category] = only_nas_repo_category
            end
        end

        @result << "    \"nas_directory\" : \"#{nas_directory}\",\n\n"

        start_first("from_nas")
        build_result_only(only_nas)
        end_first(true)
        
        start_first("to_nas")
        build_result_only(only_local)
        end_first(false)
    end
    
    def build_result_only(only_src)
        only_src.each_with_index do | (repo_name, categories), i|
            categories.each_with_index do |(name, values), j|
                start_second(name)
                values.each_with_index do |value, k|
                    has_next = true
                    has_next = false if values.size - 1 == k
                    append_third(value,has_next)
                end
                has_next = true
                has_next = false if only_src.size - 1 == i and categories.size - 1 == j
                end_second(has_next)
            end
        end
    end

end
