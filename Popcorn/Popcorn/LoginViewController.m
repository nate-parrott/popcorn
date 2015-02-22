//
//  LoginViewController.m
//  Popcorn
//
//  Created by Jessica Liang on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "EventTableViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property (nonatomic) IBOutlet UIView *loginButtonContainer;

@end

@implementation LoginViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions: @[@"public_profile", @"user_events"]];
    loginView.delegate = self;
    [self.loginButtonContainer addSubview: loginView];
    loginView.center = CGPointMake(self.loginButtonContainer.bounds.size.width/2, self.loginButtonContainer.bounds.size.height/2);
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    [[NSUserDefaults standardUserDefaults] setValue:[user objectID] forKey:@"ActiveUserId"];
    [[AppDelegate shared] didLogIn];
}

@end
