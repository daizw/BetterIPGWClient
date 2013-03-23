//
//  BGNetEngine.h
//  BetterIPGWClient
//
//  Created by shinysky on 13-3-9.
//
//

#import <Foundation/Foundation.h>

//#define IPGW_PORT 5428
#define IPGW_HOST @"its.pku.edu.cn:5428"
#define IPGW_PATH @"ipgatewayofpku"
//#define IPGW_URL @"https://its.pku.edu.cn:5428/ipgatewayofpku"
#define IPGW_UID @"uid"
#define IPGW_PASS @"password"
#define IPGW_RANGE @"range"
#define IPGW_OPERATION @"operation"
#define IPGW_TIMEOUT @"timeout"

@protocol BGNetEngineDelegate;

@interface BGNetEngine : MKNetworkEngine
{
    __weak id<BGNetEngineDelegate> delegate;
}

@property (weak) id <BGNetEngineDelegate> delegate;

+ (BGNetEngine *)sharedEngine;

- (void)forceLoginWithUsername:(NSString *)name password:(NSString*)pass global:(BOOL)isGlobal;
- (void)authWithUsername:(NSString *)name password:(NSString*)pass global:(BOOL)isGlobal;
//- (void)loginWithUsername:(NSString *)name password:(NSString*)pass global:(BOOL)isGlobal;
- (void)logoutWithUsername:(NSString *)name password:(NSString*)pass global:(BOOL)isGlobal reconnect:(BOOL)reconnect;

@end

@protocol BGNetEngineDelegate

- (void)loggedInWithResponse:(NSString*)resp;
- (void)loggedInWithError:(NSError*)error;
- (void)loggedOutWithResponse:(NSString*)resp;
- (void)loggedOutWithError:(NSError*)error;

@end