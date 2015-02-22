//
//  NPKeyboardAvoidanceView.m
//  scratch
//
//  Created by Nate Parrott on 3/18/13.
//  Copyright (c) 2013 Nate Parrott. All rights reserved.
//

#import "NPKeyboardAvoidanceView.h"

@implementation NPKeyboardAvoidanceView

-(id)init {
    self = [super init];
    [self setup];
    return self;
}
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}
-(void)awakeFromNib {
    [super awakeFromNib];
    if (self.subviews.count) self.view = self.subviews[0];
}
-(void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@synthesize view=_view;
-(void)setView:(UIView *)view {
    [_view removeFromSuperview];
    _view = view;
    _view.translatesAutoresizingMaskIntoConstraints = YES;
    [_view removeFromSuperview];
    [self addSubview:_view];
}
-(void)keyboardFrameWillChange:(NSNotification*)notif {
    _keyboardFrameInWindow = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSNumber* animationCurve = notif.userInfo[UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:animationCurve.integerValue];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect keyboardFrameInLocalCoordinates = [[[[UIApplication sharedApplication] delegate] window] convertRect:_keyboardFrameInWindow toView:self];
    
    if (CGRectIntersectsRect(keyboardFrameInLocalCoordinates, self.bounds) && keyboardFrameInLocalCoordinates.size.width*keyboardFrameInLocalCoordinates.size.height) {
        CGFloat keyboardTop = keyboardFrameInLocalCoordinates.origin.y;
        _view.frame = CGRectMake(0, 0, self.bounds.size.width, keyboardTop);
    } else {
        _view.frame = self.bounds;
    }
}

@end
