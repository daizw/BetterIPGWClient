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
    [self.GlobalSwitch setOn:[defaults boolForKey:NSDEFAULT_GLOBALIP_KEY]];
    
    self.ipLabel.text = [self getIPAddress];
    if ([self.ipLabel.text hasPrefix:@"162.105"]
        || [self.ipLabel.text hasPrefix:@"115.27"]
        || [self.ipLabel.text hasPrefix:@"202.112"]
        || [self.ipLabel.text hasPrefix:@"222.29"]
        || [self.ipLabel.text hasPrefix:@"219.223"]) {
        self.ipLabel.textColor = [UIColor whiteColor];
    } else {
        self.ipLabel.textColor = [UIColor cyanColor];
    }
    
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
    [self setAuthBtn:nil];
    [self setIpLabel:nil];
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
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

- (IBAction)userFldExit:(id)sender {
    [self.passwordFld becomeFirstResponder];
}

- (IBAction)passFldExit:(id)sender {
    [self.ConnectBtn becomeFirstResponder];
}

- (IBAction)connectBtnTapped:(id)sender {
    [self saveProfile];
    [engine forceLoginWithUsername:self.usernameFld.text
                          password:self.passwordFld.text
                            global:self.GlobalSwitch.isOn];
}

- (IBAction)authBtnTapped:(id)sender {
    [self saveProfile];
    [engine authWithUsername:self.usernameFld.text
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
    [self.statusWebView loadHTMLString:resp baseURL:[NSURL URLWithString:@"http://its.pku.edu.cn"]];
}

- (void)loggedOutWithError:(NSError*)error
{
    [self.statusWebView loadHTMLString:[error localizedFailureReason] baseURL:nil];
}

@end
