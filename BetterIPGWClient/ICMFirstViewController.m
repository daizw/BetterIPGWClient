//
//  ICMFirstViewController.m
//  BetterIPGWClient
//
//  Created by shinysky on 13-3-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ICMFirstViewController.h"

@interface ICMFirstViewController ()

@end

@implementation ICMFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setConnectBtn:nil];
    [self setDisconnectBtn:nil];
    [self setGlobalSwitch:nil];
    [self setUsernameFld:nil];
    [self setPasswordFld:nil];
    [self setStatusFld:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)connectBtnTapped:(id)sender {
    
    
}

- (IBAction)disconnectBtnTapped:(id)sender {
}

- (IBAction)globalSwitchValueChanged:(id)sender {
}
@end
