# encoding: utf-8

require_relative 'action'

$CONTENT_TREND = <<-MY_CONTENT_TREND

<!doctype html>
<!--[if IE 9]><html class="lt-ie10" lang="ko" > <![endif]-->
<html class="no-js" lang="ko" data-useragent="Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Trident/6.0)">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>FYAC Portal</title>
    <link rel="stylesheet" href="#{FOUNDATION}/css/foundation.css"/>
    <script src="#{FOUNDATION}/js/modernizr.js"></script>
</head>

<body>

    <div class="row">
        <br/>
        <h1>FYAC Portal<small>&nbsp;&nbsp;&nbsp; beta</small></h1>
        <br/>
        <br/>
    </div>
    
    <div class="row">
        <div class="large-12 columns">
            <div class="row">
            
                <div class="large-4 small-12 columns">
                    <h4>내 페이지</h4>
                    <hr>
                    <div class="panel">
                        <h5>최근 수정한 내용 <small>(9/2)</small></h5>
                    </div>

                    <li><a href="openmd://~/notes/diary-search.md">dairy-search</a></li>
                    <h6>
                    <pre>
  +2014-09-02
  +-----------
  + * DB관련
  +   * http://brown.ezphp.net/1...
  +   * http://www.okjsp.net/seq...
  +   * http://www.yes24.com/24/...
  +   * http://www.aladin.co.kr/...
  + * svn 로그 한정
  +   * svn log -r{2014-08-20}:{...
                    </pre>
                    </h6>

                    <li><a href="openmd://~/notes/work/C-tstore-07-dev-sprint-1-4.md">C-tstore-07-dev-sprint-1-4</a></li>
                    <h6>
                    <pre>
  +~~UserManager, HelpDeskManage...
  +~~** PurchaseManager ** -> 월요...
  +~~** SharedPreferenceApi ** a...
                    </pre>
                    </h6>

                    <div class="panel">
                        <h5>최근 추가된 페이지</h5>
                        <h6 class="subheader">
                            <li><a href="openmd://~/notes/hardboiled/karview.md">karview</a> <small>(9/2)</small></li>
                            <li><a href="openmd://~/notes/work/C-tstore-07-dev-sprint-1-4.md">C-tstore-07-dev-sprint-1-4</a> <small>(8/30)</small></li>
                            <li><a href="openmd://~/notes/books/http-the-definitive-guide.md">http-the-definitive-guide</a> <small>(8/24)</small></li>
                        </h6>
                    </div>

                    <p>
                        <h5><a href="openmd://~/notes/dev-game.md">dev-game</a></h5>
                        <h6 class="subheader">
<pre>
Steam
======
맥용 게임들도 제법 있는 게임 플랫폼

언어 변경하기
-------------
 * 맥용 게임 중 일부가 폰트가 엉망인 게임들...
 * 스팀 라이브러리에서 언어설정 변경 가능
 * 게임항목 - 오른쪽 버튼 메뉴 - 속성 - 언..

...
</pre>
                        </h6>
                    </p>

                </div>
                
                <div class="large-4 small-12 columns">
                    <h4>검색</h4>
                    <hr>

                    <div class="panel">
                        <h5>최근 검색어</h5>
                        <h6 class="subheader">
                            <li><a href="https://www.google.com/search?hl=ko&source=hp&q=안드로이드">안드로이드</a></li>
                            <li><a href="https://www.google.com/search?hl=ko&source=hp&q=하나스시">하나스시</a></li>
                        </h6>
                    </div>
                    
                    <p>
                        <h5><a href="http://localhost/result/result.html">내페이지 검색</a></h5>
                        <h6 class="subheader">
                            <li><a href="https://www.google.com/search?hl=ko&source=hp&q=안드로이드">안드로이드</a></li>
                            <li><a href="https://www.google.com/search?hl=ko&source=hp&q=하나스시">하나스시</a></li>
                        </h6>
                    </p>

                    <div class="panel">
                        <h5>검색 트랜드</h5>
                    </div>

                </div>
                
                <div class="large-4 small-12 columns">
                    <h4>뉴스</h4>
                    <hr>
                    <div class="panel">
                        <h5><a href="#">Post Title 1</a></h5>
                        <h6 class="subheader">
                            Risus ligula, aliquam nec fermentum vitae, sollicitudin eget urna. Suspendisse ultrices ornare tempor...
                        </h6>
                        <h6><a href="#">Read More »</a></h6>
                    </div>
                    <div class="panel hide-for-small">
                        <h5><a href="#">Post Title 2 »</a></h5>
                    </div>
                    <div class="panel hide-for-small">
                        <h5><a href="#">Post Title 3 »</a></h5>
                    </div>
                    <a href="#" class="right">Go To Blog »</a>
                </div>
            
                 
            </div>
        </div>
    </div>
     
    <footer class="row">
        <div class="large-12 columns">
            <hr>
            <p>&copy; Copyright 2014-2014 pok, All Rights Reserved.</p>
        </div>
    </footer>
     
    <script src="#{FOUNDATION}/js/jquery.js"></script>
    <script src="#{FOUNDATION}/js/foundation.min.js"></script>

</body>
</html>
MY_CONTENT_TREND

class TrendAction < Action
    def content
        return $CONTENT_TREND
    end
    
    def act(query_string)
    end
end
