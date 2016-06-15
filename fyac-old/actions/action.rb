# encoding: utf-8

RESULT_DIR = "/Library/WebServer/Documents/result"
SEARCH_RESULT = RESULT_DIR + "/result.html"
SEARCH_RESULT_HTTP = "http://localhost/result/result.html"
SEARCH_LOG = "/Library/WebServer/Documents/log/search.log"
QUERY_RESULT = RESULT_DIR + "/query.txt"
FOUNDATION = "/fyac/externs/foundation"

class Action

    def content
        return ""
    end

    def act(query_string)
    end
    
    def log(query_string, is_result_action)
        log_ip = `/sbin/ifconfig | grep 'inet.*broadcast' | awk '{print $2}'`
        log_ip.gsub!("\n", "")
        log_ip = "-" if log_ip.empty?
        log_ssid = `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | grep -E '\\<SSID\\>' | awk '{print $2}'`
        log_ssid.gsub!("\n", "")
        log_ssid = "-" if log_ssid.empty?
        log_date = `date '+%Y/%m/%d-%H:%M'`
        log_date.gsub!("\n", "")
        
        result_action = ""
        if(is_result_action)
            result_action = " _[result_action]_"
        end
        
        `echo "s1 #{log_ip} #{log_ssid} #{log_date} #{query_string}#{result_action}" >> #{SEARCH_LOG}`
    end
end

if __FILE__ == $0
    query = ARGV[0] + ARGV[1]
    Action.new.log(query, false)
end
