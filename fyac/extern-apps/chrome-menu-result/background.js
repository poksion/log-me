chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tab) {
  if (changeInfo.status == "loading") {
    var manifest = chrome.runtime.getManifest();
    var uri = manifest.permissions[1] + "/?a=seeds&q=" + encodeURIComponent(tab.url)
    var req = new XMLHttpRequest();
    req.open("GET", uri, true);
    req.send()
  }
});
