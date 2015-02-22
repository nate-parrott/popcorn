//
//  RequestTableViewController.h
//  Popcorn
//
//  Created by Nate Parrott on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RequestTableViewController : UITableViewController

@property (nonatomic) PFObject *event;

@end
