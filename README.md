# cordova-plugin-wkwebview-sync-cookies

[![Greenkeeper badge](https://badges.greenkeeper.io/psirenny/cordova-plugin-wkwebview-sync-cookies.svg)](https://greenkeeper.io/)

This works around an issue in WKWebView where cookies are not readable or settable in AJAX requests on the first app install.
Executing the plugin at the specified URL will allow the server to set cookies on the client.

## Usage

```
document.addEventListener('deviceready', () => {
  const args = ['GET', 'https://my.site.com'];
  cordova.exec('WKWebViewSync', 'sync', args);
});
```
