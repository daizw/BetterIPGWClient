//
//  ICMFirstViewController.m
//  BetterIPGWClient
//
//  Created by shinysky on 13-3-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BGFirstViewController.h"

@interface BGFirstViewController ()

@end

@implementation BGFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.usernameFld.text = [defaults stringForKey:NSDEFAULT_USERNAME_KEY];
    self.passwordFld.text = [defaults stringForKey:NSDEFAULT_PASSWORD_KEY];
    [self.GlobalSwitch setSelected:[defaults boolForKey:NSDEFAULT_GLOBALIP_KEY]];
    
    engine = [BGNetEngine sharedEngine];
    engine.delegate = self;
}

- (void)viewDidUnload
{
    [self setConnectBtn:nil];
    [self setDisconnectBtn:nil];
    [self setGlobalSwitch:nil];
    [self setUsernameFld:nil];
    [self setPasswordFld:nil];
    [self setStatusWebView:nil];
    [self setAbout:nil];
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

- (void)saveProfile {
    [[NSUserDefaults standardUserDefaults] setValue:self.usernameFld.text
                                             forKey:NSDEFAULT_USERNAME_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:self.passwordFld.text
                                             forKey:NSDEFAULT_PASSWORD_KEY];
    [[NSUserDefaults standardUserDefaults] setBool:self.GlobalSwitch.isOn
                                            forKey:NSDEFAULT_GLOBALIP_KEY];
}

- (IBAction)connectBtnTapped:(id)sender {
    [self saveProfile];
    [engine forceLoginWithUsername:self.usernameFld.text
                          password:self.passwordFld.text
                            global:self.GlobalSwitch.isOn];
}

- (IBAction)disconnectBtnTapped:(id)sender {
    [self saveProfile];
    [engine logoutWithUsername:self.usernameFld.text
                      password:self.passwordFld.text
                        global:self.GlobalSwitch.isOn
                     reconnect:NO];
}

- (IBAction)globalSwitchValueChanged:(id)sender {
    [self saveProfile];
}

# pragma mark -
# pragma mark BGNetEngineDelegate Methods

- (void)loggedInWithResponse:(NSString*)resp
{
    [self.statusWebView loadHTMLString:resp baseURL:[NSURL URLWithString:@"http://its.pku.edu.cn"]];
}

- (void)loggedInWithError:(NSError*)error
{
    [self.statusWebView loadHTMLString:[error localizedFailureReason] baseURL:nil];
}

- (void)loggedOutWithResponse:(NSString*)resp
{
    [self.statusWebView loadHTMLString:resp baseURL:nil];
}

- (void)loggedOutWithError:(NSError*)error
{
    [self.statusWebView loadHTMLString:[error localizedFailureReason] baseURL:nil];
}

@end
