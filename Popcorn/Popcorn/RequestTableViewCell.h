//
//  RequestTableViewCell.h
//  Popcorn
//
//  Created by Nate Parrott on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK.h>

@interface RequestTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *name, *issue, *location;
@property (nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic) PFObject *request;

@end
