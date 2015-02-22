//
//  UpdateComposerViewController.h
//  Popcorn
//
//  Created by Jessica Liang on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UpdateComposerViewController : UIViewController
@property NSString *eventID;
@property (nonatomic, copy) void(^completionBlock)(PFObject*);
- (instancetype) initWithEventID:(NSString*)eventID;
@end
