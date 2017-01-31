-- For whitespace ap issue
on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

-- Tell what you are doing now
on get_front_app()
	try
		tell application "System Events"
			set front_app to name of first application process whose frontmost is true
		end tell
	-- ignore all error
	on error
		set front_app to ""
	end try
    return front_app
end get_front_app

on get_window_title(front_app)
    try
        tell application front_app
            if the (count of windows) is not 0 then
                set window_title to name of front window
            end if
        end tell
    -- ignore all error
    on error
        set window_title to ""
    end try

    -- For variable not defined issue
    try
	    if window_title = missing value then set window_title to ""
    on error
	    set window_title to ""
    end try

    return window_title
end get_window_title

on get_date()
    set the_date to (do shell script "date '+%Y/%m/%d-%H:%M'")
    return the_date
end get_date

on get_ip()
    set the_ip to do shell script "/sbin/ifconfig | grep 'inet.*broadcast' | awk 'FNR == 1 {print $2}'"
    if the_ip = "" then set the_ip to "-"
    return the_ip
end get_ip


on get_ssid()
    set the_ssid to do shell script "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | grep -E '\\<SSID\\>' | awk '{print $2}'"
    if the_ssid = "" then set the_ssid to "-"

    -- replace whitespace
    set the_ssid to replace_chars(the_ssid, " ", "+")
    return the_ssid
end get_ssid

on get_server_log(log_version, query_word, with_result)
    set the_ip to get_ip()
    set the_ssid to get_ssid()
    set the_date to get_date()
    return log_version & " " & the_ip & " " & the_ssid & " " & the_date & " " & query_word & with_result
end get_server_log

on get_merged_query(argv)
    set merged_query to item 2 of argv
    repeat with i from 3 to the count of argv
        set merged_query to merged_query & " " & item i of argv
    end repeat
    return merged_query
end get_merged_query

on run argv
    if item 1 of argv is "work" then
        -- <format-id> <ip> <ssid> <date> <appname> <window-title>
        set the_ip to get_ip()
        set the_ssid to get_ssid()
        set the_date to get_date()
        set front_app to get_front_app()
        set window_title to get_window_title(front_app)
        return "a5 " & the_ip & " " & the_ssid & " " & the_date & " " & front_app & ": " & window_title
    end if

    if item 1 of argv is "search" then
        set query_word to get_merged_query(argv)
        return get_server_log("s1", query_word, "")
    end if

    if item 1 of argv is "result" then
        set query_word to get_merged_query(argv)
        return get_server_log("s1", query_word, " _[result_action]_")
    end if

    if item 1 of argv is "seeds" then
        -- s is used in search, use h as history
        set query_word to get_merged_query(argv)
        return get_server_log("h1", query_word, "")
    end if

end run

