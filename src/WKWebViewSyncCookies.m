#import "WKWebViewSyncCookies.h"
#import <Cordova/CDV.h>

@implementation WKWebViewSyncCookies

- (void)sync:(CDVInvokedUrlCommand *)command {
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

@end
