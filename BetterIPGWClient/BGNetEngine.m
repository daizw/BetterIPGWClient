//
//  BGNetEngine.m
//  BetterIPGWClient
//
//  Created by shinysky on 13-3-9.
//
//

#import "BGNetEngine.h"

@implementation BGNetEngine

@synthesize delegate;

static BGNetEngine * __sharedEngine = nil;

+ (BGNetEngine *)sharedEngine {
    @synchronized(self) {
        if (__sharedEngine == nil) {
            __sharedEngine = [[BGNetEngine alloc] init];
        }
    }
    return __sharedEngine;
}

- (BGNetEngine*)init
{
    if (self = [super initWithHostName:IPGW_HOST customHeaderFields:nil]) {
    }
    return self;
}

- (void)forceLoginWithUsername:(NSString *)name
                      password:(NSString*)pass
                        global:(BOOL)isGlobal
{
    [self logoutWithUsername:name
                    password:pass
                      global:isGlobal
                   reconnect:YES];
}
- (void)loginWithUsername:(NSString *)name
                 password:(NSString*)pass
                   global:(BOOL)isGlobal
{
    int range = isGlobal ? 1 : 2;
    MKNetworkOperation *op = [self operationWithPath:IPGW_PATH
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      name, IPGW_UID,
                                                      pass, IPGW_PASS,
                                                      [NSNumber numberWithInt:range], IPGW_RANGE,
                                                      [NSNumber numberWithInt:1], IPGW_TIMEOUT,
                                                      @"connect", IPGW_OPERATION,
                                                      nil]
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op onCompletion:^(MKNetworkOperation *operation) {
        DLog(@"%@", operation);
        unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData* data = [operation responseData];
        NSString *respStr = [[NSString alloc] initWithData:data encoding:encode];
        DLog(@"%@", respStr);
        //成功
        //连接数超过预定
        //没有包月
        [self.delegate loggedInWithResponse:respStr];
    } onError:^(NSError *error) {
        DLog(@"%@", error);
        [self.delegate loggedInWithError:error];
    }];
    
    [self enqueueOperation:op];
}

- (void)logoutWithUsername:(NSString *)name
                  password:(NSString*)pass
                    global:(BOOL)isGlobal
                 reconnect:(BOOL)reconnect
{
    int range = isGlobal ? 1 : 2;
    MKNetworkOperation *op = [self operationWithPath:IPGW_PATH
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      name, IPGW_UID,
                                                      pass, IPGW_PASS,
                                                      [NSNumber numberWithInt:range], IPGW_RANGE,
                                                      [NSNumber numberWithInt:1], IPGW_TIMEOUT,
                                                      @"disconnectall", IPGW_OPERATION,
                                                      nil]
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op onCompletion:^(MKNetworkOperation *operation) {
        DLog(@"%@", operation);
        unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData* data = [operation responseData];
        NSString *respStr = [[NSString alloc] initWithData:data encoding:encode];
        DLog(@"%@", respStr);
        //NSRange textRange =[respStr rangeOfString:@"SUCCESS=YES"];
        if (reconnect) {// && textRange.location != NSNotFound) {
            // now reconnect
            DLog(@"reconnecting...");
            [self loginWithUsername:name
                           password:pass
                             global:isGlobal];
        } else {
            [self.delegate loggedOutWithResponse:respStr];
        }
    } onError:^(NSError *error) {
        DLog(@"%@", error);
        if (reconnect) {// && textRange.location != NSNotFound) {
            // now reconnect
            DLog(@"reconnecting...");
            [self loginWithUsername:name
                           password:pass
                             global:isGlobal];
        } else {
            [self.delegate loggedOutWithError:error];
        }
    }];
    
    [self enqueueOperation:op];
}

@end
