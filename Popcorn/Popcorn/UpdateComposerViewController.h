//
//  UpdateComposerViewController.h
//  Popcorn
//
//  Created by Jessica Liang on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateComposerViewController : UIViewController
@property NSString *eventID;
- (instancetype) initWithEventID:(NSString*)eventID;
@end
