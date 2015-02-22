//
//  AppDelegate.m
//  Popcorn
//
//  Created by Nate Parrott on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "EventTableViewController.h"
#import <Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // setup parse
    [Parse setApplicationId:@"kozJXHacqMmoSeNU5QtOBXq4sYva9imTxuMGBVvl" clientKey:@"ROlcrVBNkdz4heuyf8e2z87bbaZAbBRutjvjszBE"];
    
    // Initialize our window.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.tintColor = [UIColor colorWithRed:0.998605668545 green:0.248933106661 blue:0.770995974541 alpha:1.0];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_events"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *sessison, FBSessionState state, NSError *error) {
                                          if (state == FBSessionStateOpen) {
                                              self.window.rootViewController = [[EventTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                          }
                                      }];
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        [self.window setRootViewController:loginViewController];

    }
    
    // Configure our application.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    [self doPostLaunchSplashAnimation];
    
    return YES;
}

- (void)doPostLaunchSplashAnimation {
    CGFloat radius = sqrtf(powf(self.window.rootViewController.view.bounds.size.width/2, 2) + powf(self.window.rootViewController.view.bounds.size.height/2, 2));
    
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
    [self.window.rootViewController.view addSubview:cover];
    cover.center = CGPointMake(cover.superview.bounds.size.width/2, cover.superview.bounds.size.height/2);
    cover.backgroundColor = [UIColor colorWithRed:0.984 green:0.090 blue:0.725 alpha:1.000];
    UIImageView *popcorn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Popcorn"]];
    [popcorn sizeToFit];
    [cover addSubview:popcorn];
    cover.layer.cornerRadius = radius;
    cover.clipsToBounds = YES;
    popcorn.center = CGPointMake(cover.bounds.size.width/2, cover.bounds.size.height/2);
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        cover.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        [cover removeFromSuperview];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

+ (AppDelegate *)shared {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)isHostOfEvent:(PFObject *)event {
    return [[event valueForKey:@"staffFbids"] containsObject:[FBSession activeSession].accessTokenData.userID];
}

@end
