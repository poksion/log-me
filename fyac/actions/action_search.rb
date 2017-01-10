# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'shellwords'

require_relative 'action'
require_relative '../../common/lib/config-loader'

class SearchAction < Action
  def content
    @cnt.to_s + " results"
  end

  def act(query_string)
    @cnt = 0
    root_dir = File.expand_path( File.dirname( File.dirname(File.dirname(__FILE__)) ) )

    begin
      result = ""

      query = query_string.split

      candi_results = nil
      query.each do | word |
        if(candi_results == nil)
          local_dn_script = File.join(root_dir, 'digital-nomad-bin/dn')
          candi_results_str = `#{local_dn_script} grep_cgi #{word}`
          escaped_candi = Shellwords.escape(candi_results_str)
          
          result_raw_file = File.join(root_dir, 'fyac/public/result/result_raw.txt')
          `echo #{escaped_candi} > #{result_raw_file}`
          candi_results = candi_results_str.split("\n")
        end
        candi_results_tmp = Array.new
        candi_results.each do | content |
          if(content.include?(".xml:"))
            next
          end
          dilimiter = nil
          if(content.include?(".md:"))
            dilimiter = ".md:"
          elsif(content.include?(".txt:"))
            dilimiter = ".txt:"
          end
          if(dilimiter != nil)
            content_arry = content.split(dilimiter)
            escaped_content = Shellwords.escape(content)
            ret = `echo #{escaped_content} | grep --color=always #{word}`
            if(ret != "")
              content_file = content_arry[0]
              content_body = ret.split(dilimiter)[1]
              if(content_body == nil)
                candi_results_tmp << ret;
              else
                candi_results_tmp << (content_file + dilimiter + content_body)
              end
            end
          end
        end
        candi_results = candi_results_tmp
      end
      candi_results.each do |content|
        result += content
      end

      result_file = File.join(root_dir, 'fyac/public/result/result.html')
      file = File.open(result_file, "w")

      header = <<-HEADER
             <!DOCTYPE html>
              <html lang="ko">
              <head>
                <meta http-equiv="Pragma" content="no-cache">
                <meta http-equiv="Expires" content="-1">
                <meta charset="utf-8" />
                <title>FYAC result</title>
              </head>
              <body>
                <pre>
      HEADER

      footer = <<-FOOTER
                </pre>
              </body>
            </html>
      FOOTER
      file.write(header)

      text = ""
      result.lines.each do |line|
        if (false == line.include?(": Permission denied") and line.valid_encoding?)
          @cnt += 1
          if(line.include?(".md:"))
            line.gsub!(/^.*\/Dropbox\/Notes\//, '<a href="openmd://~/notes/');
            line.gsub!(/(~\/notes\/.*\.md)/, '\1">\1</a>');
            line.gsub!(/^.*\/Dropbox\/public\/blog\//, '<a href="openmd://~/blog/');
            line.gsub!(/(~\/blog\/.*\.md)/, '\1">\1</a>');
            line.gsub!(/^.*\/Box Sync\/작업문서\/작업중\//, '<a href="openmd://~/workspace/box-working-docs/');
            line.gsub!(/(~\/workspace\/box-working-docs\/.*\.md)/, '\1">\1</a>');
          end
          line.gsub!("[01;31m[K", '<span style="color:red">');
          line.gsub!("[m[K", '</span>');
          text += line
        end
      end
      text = "뜨거운 MD : " +
          "<a href=\"openmd://~/notes/algo-study/journal.md\">algo-study 일기</a> / " +
          "<a href=\"openmd://~/notes/diary-dev.md\">개발일지</a> / " +
          "<a href=\"openmd://~/notes/work/2014-daily-work-journal.md\">회사일지</a>\n\n" +
          '검색어 : <span style="color:red">' + query_string + '</span> 의 검색결과(총 ' +
          @cnt.to_s + "개) | memo on diary : <a href=\"openmd://~/notes/diary-search.md\">search</a>\n\n" + text
      file.write(text)

      file.write(footer)

      `echo #{query_string} > #{get_query_result_fullpath()}`
      log(query_string, :search)

    rescue IOError => e
      #some error occur (eg. DIR not writable, etc.)
    ensure
      file.close unless file == nil
    end

  end
end
