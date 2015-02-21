//
//  PinAnnotationView.m
//  Popcorn
//
//  Created by Nate Parrott on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import "PinAnnotationView.h"

@interface PinAnnotationView ()

@property (nonatomic) UILabel *label;
@property (nonatomic) UIImageView *triangle;

@end

@implementation PinAnnotationView

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    if (!self.label) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        
        self.triangle = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"triangle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self addSubview:self.triangle];
        
        self.label = [UILabel new];
        [self addSubview:self.label];
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont boldSystemFontOfSize:15];
        
        self.backgroundColor = self.tintColor;
        self.triangle.tintColor = self.tintColor;
    }
    self.label.text = [annotation title];
    [self.label sizeToFit];
    CGFloat yPadding = 5;
    CGFloat xPadding = 10;
    self.bounds = CGRectMake(0, 0, self.label.frame.size.width + xPadding * 2, self.label.frame.size.height + yPadding * 2);
    self.label.frame = CGRectMake(xPadding, yPadding, self.label.frame.size.width, self.label.frame.size.height);
    [self.triangle sizeToFit];
    self.triangle.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height + self.triangle.frame.size.height/2);
    
    /*UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius];
    self.layer.shadowRadius = 2;
    self.layer.shadowPath = shadowPath.CGPath;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowColor = [UIColor blackColor].CGColor;*/
    
    [super setAnnotation:annotation];
}

- (CGPoint)centerOffset {
    return CGPointMake(0, -self.bounds.size.height/2 - self.triangle.frame.size.height);
}

@end
