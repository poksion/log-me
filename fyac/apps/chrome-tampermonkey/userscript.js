// ==UserScript==
// @name       SearchJump local
// @namespace  http://poksion.net/
// @version    0.1
// @include    https://www.google.co.kr/webhp?*
// ==/UserScript==

// Modifications
// ---------------------------------
// searchenginearray[i][0] - Search engine name
// searchenginearray[i][1] - Querystring variable key for keywords entered
// searchenginearray[i][2] - URL portion identifying search from this engine
// searchenginearray[i][3] - Search URL ("--keywords--" to be replaced by searched-for keywords)
// searchenginearray[i][4] - Whether to show this engine in list or not
// searchenginearray[i][5] - Search engine favicon



(function() {

	var searchenginearray = new Array();
	var lg = new Array();
	
//	위키페디아 : http://en.wikipedia.org/w/index.php?title=Special:Search&search=%s
//	네이버 : http://search.naver.com/search.naver?query=%s
//	네이버 맵 : http://map.naver.com/?query=%s
//	예스24 : http://www.yes24.com/SearchCenter/SearchResult.aspx?query=%s
//	Ruby-Doc : http://www.ruby-doc.org/q/%s
//	cplusplus : http://www.cplusplus.com/search.do?q=%s

	searchenginearray[0] = new Array('위키페디아', 'q', 'google.', 'http://en.wikipedia.org/w/index.php?title=Special:Search&search=--keywords--', 1, 'http://www.google.co.uk/favicon.ico');
	searchenginearray[1] = new Array('네이버', 'q', 'google.', 'http://search.naver.com/search.naver?query=--keywords--', 1, 'http://www.google.co.uk/favicon.ico');
	searchenginearray[2] = new Array('네이버 맵', 'p', 'search.yahoo.', 'http://map.naver.com/?query=--keywords--', 1, 'http://www.yahoo.com/favicon.ico');
	searchenginearray[3] = new Array('예스24', 'p', 'search.yahoo.', 'http://www.yes24.com/SearchCenter/SearchResult.aspx?query=--keywords--', 1, 'http://www.yahoo.com/favicon.ico');
	searchenginearray[4] = new Array('Ruby-Doc', 'q', 'search.msn.', 'http://ruby-doc.com/search.html?q=--keywords--', 1, 'http://search.msn.com/favicon.ico');
	searchenginearray[5] = new Array('cplusplus', 'q', 'search.msn.', 'http://www.cplusplus.com/search.do?q=--keywords--', 1, 'http://search.msn.com/favicon.ico');

//	searchenginearray[0] = new Array('Google', 'q', 'google.', 'http://www.google.com/search?q=--keywords--', 0, 'http://www.google.co.uk/favicon.ico');
//	searchenginearray[1] = new Array('Google UK', 'q', 'google.', 'http://www.google.co.uk/search?q=--keywords--', 0, 'http://www.google.co.uk/favicon.ico');
//	searchenginearray[2] = new Array('Yahoo', 'p', 'search.yahoo.', 'http://search.yahoo.com/search?p=--keywords--', 1, 'http://www.yahoo.com/favicon.ico');
//	searchenginearray[3] = new Array('Yahoo UK', 'p', 'search.yahoo.', 'http://search.yahoo.co.uk/search?p=--keywords--', 0, 'http://www.yahoo.com/favicon.ico');
//	searchenginearray[4] = new Array('MSN', 'q', 'search.msn.', 'http://search.msn.com/results.aspx?q=--keywords--&amp;FORM=QBHP', 1, 'http://search.msn.com/favicon.ico');
//	searchenginearray[5] = new Array('MSN UK', 'q', 'search.msn.', 'http://search.msn.co.uk/results.aspx?q=--keywords--&amp;FORM=QBHP', 0, 'http://search.msn.com/favicon.ico');

	searchenginearray[6] = new Array('Ask', 'ask', 'ask.', 'http://web.ask.com/web?q=--keywords--&amp;qsrc=0&amp;o=0', 0, 'http://www.ask.com/favicon.ico');
	searchenginearray[7] = new Array('Ask', 'q', 'ask.', 'http://web.ask.com/web?q=--keywords--&amp;qsrc=0&amp;o=0', 0, 'http://www.ask.com/favicon.ico');
	searchenginearray[8] = new Array('Yahoo Directory', 'p', 'search.yahoo.', 'http://search.yahoo.com/search/dir?p=--keywords--', 0, 'http://www.yahoo.com/favicon.ico');
	searchenginearray[9] = new Array('DMOZ', 'search', 'dmoz.org', 'http://search.dmoz.org/cgi-bin/search?search=--keywords--', 0, 'http://dmoz.org/favicon.ico');
	searchenginearray[10] = new Array('AllTheWeb', 'q', 'alltheweb.co', 'http://www.alltheweb.com/search?cat=web&q=--keywords--', 0, 'http://www.alltheweb.com/favicon.ico');
	searchenginearray[11] = new Array('AltaVista', 'q', 'altavista.co', 'http://www.altavista.com/web/results?itag=ody&q=--keywords--', 0, 'http://www.altavista.com/favicon.ico');
	searchenginearray[12] = new Array('LookSmart', 'qt', 'search.looksmart.', 'http://search.looksmart.com/p/search?free=1&qt=--keywords--', 0, 'http://search.looksmart.com/favicon.ico');
	searchenginearray[13] = new Array('Lycos', 'query', 'lycos.co', 'http://search.lycos.com/default.asp?loc=searchbox&tab=web&query=--keywords--', 0, 'http://www.lycos.com/favicon.ico');

	var toggle = 'left';
	var togglew;
    var b = document.getElementById("searchSideBar");
	//var linkstyle =     "text-align: left; white-space: nowrap; text-decoration: none; background: #fff; margin: 0 10px 3px 10px; padding: 3px 8px 3px 20px; display: block; color: #00c;";
    var linkstyle =       "text-align: left; white-space: nowrap; text-decoration: none; background: #fff; margin: 0 10px 3px 10px; padding: 3px 8px 3px 8px; display: block;";
	var footerlinkstyle = "text-align: left; white-space: nowrap; text-decoration: none; background: #fff; margin: 0 10px 3px 10px; padding: 3px 8px 3px 8px; display: block;";

    var keywords = document.location.href;
    keywords = keywords.replace(/\+/g, "%20");
    keywords = decodeURIComponent(keywords);
    var pos = keywords.indexOf("&q=");
    if( pos > -1 ){
        keywords = encodeURIComponent(keywords.substring(pos + 3));
    }

    function make_boxes() {
        if ((!b) && (keywords != '')) {
            b = document.createElement("div");
            b.setAttribute("id","searchSideBar");
            b.setAttribute("style","position: fixed; bottom: 20px; right: 0; padding: 10px 0; background: #eee; border: 1px solid #ccc; border-right: 0; width: 150px; overflow: hidden;");

				for (i = 0; i < searchenginearray.length; i++) {

					if (searchenginearray[i][4] == 1) {
						lg[i] = document.createElement("a")
						lg[i].setAttribute("href", searchenginearray[i][3].replace('--keywords--', keywords));
						lg[i].setAttribute("target", "_blank");
						lg[i].setAttribute("style", linkstyle);
						addtext(lg[i], searchenginearray[i][0]);
						b.appendChild(lg[i]);

					}

				}

                ls = document.createElement("span")
                ls.setAttribute("style", "text-decoration: none; margin: 0 10px 3px 10px; padding: 3px 8px 3px 8px; display: block; color: #ddf; font-size: 80%; overflow: hidden;");
				addtext(ls, " ");
                b.appendChild(ls);
            
                lmy = document.createElement("p")
                lmy.setAttribute("style", footerlinkstyle);
                var lmy_content = document.createTextNode("Loading...");
                lmy.appendChild(lmy_content);
                b.appendChild(lmy);
            
                GM_xmlhttpRequest({
                  method: "GET",
                  url: "http://localhost/fyac/main.rb?a=search&q=" + keywords,
                  onload: function(response) {
                    //alert(response.responseText);
                    lmy_content.nodeValue = response.responseText;
                  }
                });
            
                lopen = document.createElement("a")
                lopen.setAttribute("href", "http://localhost/fyac/main.rb?a=result")
                lopen.setAttribute("target", "_blank");
                lopen.setAttribute("style", footerlinkstyle);
                addtext(lopen, "Open result");
                b.appendChild(lopen);

            
                lc = document.createElement("a")
                lc.setAttribute("style", footerlinkstyle);
                lc.setAttribute("href","#");
                lc.setAttribute("onClick","return false;");
				addtext(lc, 'Hide \u00BB');
                b.appendChild(lc);
				lc.style.textAlign = 'right';

            document.body.appendChild(b);
			b.addEventListener("click", toggle_box, false);
            return true;
        }
    }

	function toggle_box() {
		// Toggle tells you which way the box was last moved
		togglew = eval(b.style.width.replace(/px/,""));
		if (toggle == 'right') {
			for (i = togglew; i < 150; i++) {
				b.style.width = (i) + 'px';
			}
			toggle = 'left';
		} else {
			for (i = togglew; i > 5; i--) {
				b.style.width = (i) + 'px';
			}
			toggle = 'right';
		}
	}

	function go() {
		make_boxes();
	}

	function addtext(obj, text) {
		var content = document.createTextNode(text);
		obj.appendChild(content)
	}

	function addEvent(objObject, strEventName, fnHandler) { 
		// DOM-compliant way to add an event listener 
		if (objObject.addEventListener) 
			objObject.addEventListener(strEventName, fnHandler, false); 
		// IE/windows way to add an event listener 
		else if (objObject.attachEvent) 
			objObject.attachEvent("on" + strEventName, fnHandler); 
	}
	
	window.addEventListener("load", go(), false);

})();