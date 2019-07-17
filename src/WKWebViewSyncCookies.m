/*
Copyright 2017 Dennis Torres
Thanks to @CWBudde for iOS 11 fixes.
*/

#import "WKWebViewSyncCookies.h"
#import <Cordova/CDV.h>

@implementation WKWebViewSyncCookies

- (void)sync:(CDVInvokedUrlCommand *)command {
  WKWebView* wkWebView = (WKWebView*) self.webView;
  if (@available(iOS 11.0, *)) {
    NSString *domain = command.arguments[2];
    NSString *path = command.arguments[3];

    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"foo" forKey:NSHTTPCookieName];
    [cookieProperties setObject:@"bar" forKey:NSHTTPCookieValue];
    [cookieProperties setObject:domain forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:domain forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:path forKey:NSHTTPCookiePath];
    NSHTTPCookie * cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];

    [wkWebView.configuration.websiteDataStore.httpCookieStore setCookie:cookie completionHandler:^{NSLog(@"Cookies synced");}];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
  } else {
    @try {
      NSString *urlHttpMethod = command.arguments[0];
      NSString *urlString = command.arguments[1];
      NSURL *url = [NSURL URLWithString:urlString];

      NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
      [urlRequest setHTTPMethod:urlHttpMethod];
      [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];

      NSURLSession *urlSession = [NSURLSession sharedSession];

      [[urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable urlResponse, NSError * _Nullable error) {
        CDVPluginResult *result;

        if (error) {
          result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
        } else {
          result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }

        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
      }] resume];
    }
    @catch (NSException *exception) {
      CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.reason];
      [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
  }
}

@end
