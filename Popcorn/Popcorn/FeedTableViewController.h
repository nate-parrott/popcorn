//
//  FeedTableViewController.h
//  Popcorn
//
//  Created by Jessica Liang on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse.h>

@interface FeedTableViewController : UITableViewController
@property PFObject* event;
@property NSArray *posts;
@property BOOL  isStaff;
- (instancetype) initWithStyle:(UITableViewStyle)style event:(PFObject*) event isStaff:(BOOL)staff;
@end
