var fyacResultView = {

	requestShow : function() {
		var manifest = chrome.runtime.getManifest();
		var uri = manifest.permissions[1] + "/result/result.html"
		var req = new XMLHttpRequest();
		req.open("GET", uri, true);
		req.responseType = "document"
		req.onload = this.makeBody_.bind(this);
		req.send(null);
	},

	makeBody_ : function(e) {
		document.body.innerHTML = e.target.responseXML.body.innerHTML;
		var links = document.getElementsByTagName("a");
		for (var i = 0; i < links.length; i++) {
			(function() {
				var ln = links[i];
				var location = ln.href;
				ln.onclick = function() {
					var activeNewTab = true;
					if (location.indexOf("openmd://") != -1) {
						activeNewTab = false;
					}
					chrome.tabs.create({active : activeNewTab, url : location}, function(tab) {
//						if(activeNewTab == false){
//							setTimeout(function() { chrome.tabs.remove(tab.id);}, 1000);
//						}
					});
				};
			})();
		}
	}
};

// Run our kitten generation script as soon as the document's DOM is ready.
document.addEventListener('DOMContentLoaded', function() {
	fyacResultView.requestShow();
});
