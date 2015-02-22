//
//  FeedCardView.m
//  Popcorn
//
//  Created by Jessica Liang on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import "FeedCardView.h"

@implementation FeedCardView
- (instancetype)initWithPost:(PFObject*) post andFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.post = post;
        [self setBackgroundColor: [UIColor whiteColor]];
        [self setOpaque:YES];
        [self.layer setCornerRadius:3.0f];
    }
    return self;
}

- (void)layoutSubviews {
    CGSize titleSize = [self.post[@"title"] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]}];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(6, 4, self.frame.size.width - 8, titleSize.height)];
    [headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
    [headerLabel setTextColor:self.tintColor];
    [headerLabel setText:self.post[@"title"]];
    [self addSubview:headerLabel];
    CGSize messageSize = [self.post[@"message"] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]}];
    CGRect messageDims = [self.post[@"message"] boundingRectWithSize:CGSizeMake(self.frame.size.width - 8, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]}
                                              context:nil];
    UITextView *message = [[UITextView alloc] initWithFrame: CGRectMake(4, headerLabel.frame.size.height+6, messageDims.size.width, messageDims.size.height)];
    message.editable = NO;
    message.textContainerInset = UIEdgeInsetsZero;
    message.textContainer.lineFragmentPadding = 0;
    [message setUserInteractionEnabled:NO];
    [message setText:self.post[@"message"]];
    [message setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
    [self addSubview:message];
    
    if (self.post[@"photo"]) {
        PFFile *postImage = self.post[@"photo"];
        [postImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                CGFloat photoHeight = (CGFloat)[self.post[@"aspectRatio"] doubleValue]*([UIScreen mainScreen].bounds.size.width - 16);
                if (!self.image) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(4, headerLabel.frame.size.height+6 + message.frame.size.height, self.frame.size.width - 8, photoHeight)];
                    [self.image setImage:image];
                }
                self.image.contentMode = UIViewContentModeScaleAspectFill;
                self.image.clipsToBounds = YES;
                
                [self addSubview:self.image];
            }
        }];
    }
    

}
+ (CGFloat)heighForPost: (PFObject*)post {
    CGRect messageDims = [post[@"message"] boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 8, CGFLOAT_MAX)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]}
                                                             context:nil];
    CGSize titleSize = [post[@"title"] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]}];
    CGFloat photoHeight = 0;
    if (post[@"photo"]) {
        photoHeight = (CGFloat)[post[@"aspectRatio"] doubleValue]*([UIScreen mainScreen].bounds.size.width - 16);
    }
    
    return titleSize.height + messageDims.size.height + photoHeight+ 12;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
