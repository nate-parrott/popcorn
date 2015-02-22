//
//  NPKeyboardAvoidanceView.h
//  scratch
//
//  Created by Nate Parrott on 3/18/13.
//  Copyright (c) 2013 Nate Parrott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPKeyboardAvoidanceView : UIView {
    BOOL _setupYet;
    CGRect _keyboardFrameInWindow;
}

@property(assign, nonatomic)UIView* view;

@end
