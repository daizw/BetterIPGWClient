//
//  ICMFirstViewController.h
//  BetterIPGWClient
//
//  Created by shinysky on 13-3-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICMFirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordFld;
@property (weak, nonatomic) IBOutlet UIButton *ConnectBtn;
@property (weak, nonatomic) IBOutlet UIButton *DisconnectBtn;
@property (weak, nonatomic) IBOutlet UISwitch *GlobalSwitch;
@property (weak, nonatomic) IBOutlet UITextField *StatusFld;

- (IBAction)connectBtnTapped:(id)sender;
- (IBAction)disconnectBtnTapped:(id)sender;
- (IBAction)globalSwitchValueChanged:(id)sender;


@end
