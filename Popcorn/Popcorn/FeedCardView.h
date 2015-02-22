//
//  FeedCardView.h
//  Popcorn
//
//  Created by Jessica Liang on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FeedCardView : UIView
@property PFObject *post;
- (id)initWithPost:(PFObject*) post andFrame:(CGRect)frame;
+ (CGFloat)heighForPost: (PFObject*)post;
@end
