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

@interface EventTabBarViewController ()

@end

@implementation EventTabBarViewController

- (instancetype)initWithEvent:(PFObject *)event {
    self = [super init];
    
    FeedTableViewController *feed = [[FeedTableViewController alloc] initWithStyle:UITableViewStylePlain];
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
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:feed];
    self.viewControllers = @[nav];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
