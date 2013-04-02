//
//  ICMFirstViewController.h
//  BetterIPGWClient
//
//  Created by shinysky on 13-3-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGNetEngine.h"

#define NSDEFAULT_USERNAME_KEY @"username"
#define NSDEFAULT_PASSWORD_KEY @"password"
#define NSDEFAULT_GLOBALIP_KEY @"isGlobal"

@interface BGFirstViewController : UIViewController <BGNetEngineDelegate>
{
    BGNetEngine* engine;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordFld;
@property (weak, nonatomic) IBOutlet UIButton *ConnectBtn;
@property (weak, nonatomic) IBOutlet UIButton *DisconnectBtn;
@property (weak, nonatomic) IBOutlet UIButton *AuthBtn;
@property (weak, nonatomic) IBOutlet UISwitch *GlobalSwitch;
@property (weak, nonatomic) IBOutlet UIWebView *statusWebView;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;

- (IBAction)userFldExit:(id)sender;
- (IBAction)passFldExit:(id)sender;
- (IBAction)connectBtnTapped:(id)sender;
- (IBAction)authBtnTapped:(id)sender;
- (IBAction)disconnectBtnTapped:(id)sender;
- (IBAction)globalSwitchValueChanged:(id)sender;


@end
