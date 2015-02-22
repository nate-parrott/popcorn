//
//  RequestTableViewCell.m
//  Popcorn
//
//  Created by Nate Parrott on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import "RequestTableViewCell.h"
#import <FacebookSDK.h>

@interface RequestTableViewCell ()

@property (nonatomic) BOOL done;

@end

@implementation RequestTableViewCell

- (void)setRequest:(PFObject *)request {
    _request = request;
    self.name.text = @"";
    self.profilePic.image = nil;
    self.issue.text = [request valueForKey:@"message"];
    self.location.text = [request valueForKey:@"location"];
    self.done = [[request valueForKey:@"resolved"] boolValue];
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@", self.request[@"fbid"]]
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              if (self.request == request) {
                                  self.name.text = result[@"name"];
                              }
                          }];
}

- (void)setDone:(BOOL)done {
    _done = done;
    [self.doneButton setTitle:done ? @"Resolved": @"Mark resolved" forState:UIControlStateNormal];
}

- (IBAction)toggleDone:(id)sender {
    self.done = !self.done;
    [self.request setValue:@(self.done) forKey:@"resolved"];
    [self.request saveInBackground];
}

@end
