//
//  EventTabBarViewController.m
//  Popcorn
//
//  Created by Jessica Liang on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import "EventTabBarViewController.h"
#import "FeedTableViewController.h"
#import <FacebookSDK.h>
#import "MapViewController.h"
#import "GetHelpViewController.h"
#import "RequestTableViewController.h"
#import "AppDelegate.h"

@interface EventTabBarViewController ()

@end

@implementation EventTabBarViewController

- (instancetype)initWithEvent:(PFObject *)event {
    self = [super init];
    
    NSMutableArray *tabs = [NSMutableArray new];
    
    FeedTableViewController *feed = [[FeedTableViewController alloc] initWithStyle:UITableViewStylePlain event:event isStaff:[event[@"staffFbids"] containsObject:[FBSession activeSession].accessTokenData.userID]];
    [tabs addObject:feed];
    
    MapViewController *map = [[MapViewController alloc] init];
    map.event = event;
    [tabs addObject:map];
    
    GetHelpViewController *getHelpVC = [[GetHelpViewController alloc] initWithNibName:@"GetHelpViewController" bundle:nil];
    getHelpVC.event = event;
    [tabs addObject:getHelpVC];
    
    if ([[AppDelegate shared] isHostOfEvent:event]) {
        RequestTableViewController *requestVC = [[UIStoryboard storyboardWithName:@"RequestTableStoryboard" bundle:nil] instantiateInitialViewController];
        requestVC.event = event;
        requestVC.tabBarItem.image = [UIImage imageNamed:@"inbox"];
        [tabs addObject:requestVC];
    }
    // get the event title:
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@", event[@"fbid"]]
                                 parameters: nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              NSLog(@"%@", result);
                              feed.title = result[@"name"];
                          }];
    self.viewControllers = tabs;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
