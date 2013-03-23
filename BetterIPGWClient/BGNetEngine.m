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
    if (self = [super initWithHostName:IPGW_HOST
                    customHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:
                                        @"Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25", @"User-Agent",
                                        @"https://its.pku.edu.cn/itsmobile/wLogin.html", @"Referer",
                                                                     nil]]) {
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

- (NSString *)decodeString:(NSData *)data
{
    NSString *respStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if(respStr == NULL)
    {
        unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        respStr = [[NSString alloc] initWithData:data encoding:encode];
    }
    if(respStr == NULL)
    {
        respStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    }
    return respStr;
}

- (void)authStep2
{
    {
        MKNetworkOperation *op = [self operationWithURLString:@"https://its.pku.edu.cn/netportal/PKUIPGW"
                                                       params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               @"open", @"cmd",
                                                               @"ca", @"type",
                                                               @"0", @"fr",
                                                               nil]
                                                   httpMethod:@"POST"];
        
        [op onCompletion:^(MKNetworkOperation *operation) {
            DLog(@"%@", operation);
            NSString *respStr = [self decodeString:[operation responseData]];
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
}
- (void)authWithUsername:(NSString *)name
                password:(NSString*)pass
                  global:(BOOL)isGlobal
{
    MKNetworkOperation *op = [self operationWithURLString:@"https://its.pku.edu.cn/cas/login"
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      name, @"username1",
                                                      pass, @"password",
                                                      @"1|;kiDrqvfi7d$v0p5Fg72Vwbv2;|2|;kiDrqvfi7d$v0p5Fg72Vwbv2;|14",
                                                      @"username",
                                                      nil]
                                          httpMethod:@"POST"];
    
    [op onCompletion:^(MKNetworkOperation *operation) {
        DLog(@"%@", operation);
        NSString *respStr = [self decodeString:[operation responseData]];
        DLog(@"respStr: %@", respStr);
        //成功
        //连接数超过预定
        //没有包月
        [self.delegate loggedInWithResponse:respStr];
        //[self authStep2];
    } onError:^(NSError *error) {
        DLog(@"%@", error);
        [self.delegate loggedInWithError:error];
    }];
    
    [self enqueueOperation:op];
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
        NSString *respStr = [self decodeString:[operation responseData]];
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
        NSString *respStr = [self decodeString:[operation responseData]];
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
