# cordova-plugin-wkwebview-sync-cookies

This works around an issue in WKWebView where cookies are not readable or settable in AJAX requests on the first app install.
Executing the plugin at the specified URL will allow the server to set cookies on the client.

## Usage

```
document.addEventListener('deviceready', () => {
  const args = ['GET', 'https://my.site.com'];
  cordova.exec('WKWebViewSync', 'sync', args);
});
```
