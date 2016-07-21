# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require 'base64'
require 'cgi'

class NasFileManager

  def initialize(action, encoded_files)
    @action = action
    @encoded_files = encoded_files
  end
  
  def get_begin_body_view(use_ng_app, cnt)
    begin_body = %{<!DOCTYPE html>
<!--[if IE 9]><html class="lt-ie10" lang="ko" > <![endif]-->
<html class="no-js" lang="ko" >

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>nas file manager</title>

  <!-- If you are using CSS version, only link these 2 files, you may add app.css to use for your overrides if you like. -->
  <link rel="stylesheet" href="/foundation/css/normalize.css">
  <link rel="stylesheet" href="/foundation/css/foundation.min.css">
  <script src="/foundation/js/vendor/custom.modernizr.js"></script>

  <script src="/apps/bower_components/angular/angular.min.js"></script>
  <script src="/apps/bower_components/angular-utf8-base64/angular-utf8-base64.min.js"></script>
  
  <link rel="stylesheet" href="/apps/nas-file-manager/app.css">
  <script src="/apps/nas-file-manager/app.js"></script>

</head>

}
    if use_ng_app
      begin_body += %{<body ng-app="nasFileManager" ng-controller="FileController" ng-init="initList(#{cnt})">}
    else
      begin_body += %{<body>}
    end
  end
  
  def get_end_body_view()
%{
  <script src="/foundation/js/vendor/jquery.js"></script>
  <script src="/foundation/js/foundation.min.js"></script>
  <script>
    $(document).foundation();
  </script>
</body>

</html>
}
  end
  
  def get_file_manager_view(cnt, file_item_view)
%{#{get_begin_body_view(true, cnt)}
  <div class="row">
    <div class="small-10 small-centered columns">
       <div class="row">
         <div class="small-1 columns file-list-header"><input type="checkbox" ng-model="fileAll" ng-click="checkAllFiles()" style="margin:0;"></div>
         <div class="small-3 columns file-list-header">미리보기</div>
         <div class="small-8 columns file-list-header">파일이름</div>
       </div>
       #{file_item_view}
    </div>
  </div>

  <div class="row">
    <div class="small-4 small-centered columns"><button type="button" class="tiny delete-button" ng-click="deleteFiles()">선택파일 삭제하기</button></div>
  </div>
#{get_end_body_view()}
}
  end
  
  def get_file_item_view(files)
    result = ""
    idx = 0
    files.each do |file|
      item_view = %{
       <div class="row" data-equalizer>
         <div class="small-1 columns file-list-item" data-equalizer-watch><input type="checkbox" ng-model="file[#{idx}]" ng-click="checkFile()" style="margin:0;"></div>
         <div class="small-3 columns file-list-item" data-equalizer-watch><img src="/nas-file-manager?a=view&ef=#{CGI::escape(file)}"></div>
         <div class="small-8 columns file-list-item" data-equalizer-watch ng-init="setFileName(#{idx}, '#{file}')" >#{file}</div>
       </div>
      }
      result += item_view
      idx += 1
    end
    return result
  end
  
  def get_delete_success_view(filesStr)
%{#{get_begin_body_view(false, 0)}
  <div class="row">
    <p>#{filesStr}이 정상 삭제되었습니다</p>
    <button type="button" onclick="window.open('about:blank','_self').close();">닫기</button>
  </div>
#{get_end_body_view()}
}
  end
  
  def read_img(encoded_file)
    file = CGI::unescape(encoded_file)
    file = File.join(File.dirname(__FILE__), 'nas-file-not-exist.png') unless File.exist? file
    File.read(file)
  end
  
  def delete_files(files)
    files.each do |file|
      File.delete(file)
    end
  end

  def get_response()
    if @action == 'view'
      read_img(@encoded_files)
    elsif @action == 'delete'
      files = Base64.decode64( @encoded_files ).force_encoding('UTF-8').split(", ")
      delete_files(files)
      get_delete_success_view(files.join(", "))
    else
      files = Base64.decode64( @encoded_files ).force_encoding('UTF-8').split(", ")
      get_file_manager_view(files.length, get_file_item_view(files))
    end
  end

end
