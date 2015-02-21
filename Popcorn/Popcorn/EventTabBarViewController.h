//
//  EventTabBarViewController.h
//  Popcorn
//
//  Created by Jessica Liang on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse.h>

@interface EventTabBarViewController : UITabBarController

- (instancetype)initWithEvent:(PFObject *)event;

@end
