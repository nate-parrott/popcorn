//
//  UpdateComposerViewController.m
//  Popcorn
//
//  Created by Jessica Liang on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import "UpdateComposerViewController.h"
#import <Parse/Parse.h>

@interface UpdateComposerViewController ()
@property UITextView *messageComposer;
@property UITextField *titleField;
@end

@implementation UpdateComposerViewController

- (instancetype) initWithEventID:(NSString*)eventID {
    self = [super init];
    self.eventID = eventID;
    return self;
}

- (void)viewDidLoad {
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Post"
                                   style: UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(postUpdate:)];
    self.navigationItem.rightBarButtonItem = postButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style: UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(dismissView:)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = postButton;

    
    [super viewDidLoad];
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(8, 68, self.view.frame.size.width, 30)];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(8, self.titleField.frame.size.height + 4 + 68, self.titleField.frame.size.width - 16, 1)];
    [separator setBackgroundColor:[UIColor lightGrayColor]];
    [self.titleField setPlaceholder:@"Title goes here"];
    [self.view addSubview:self.titleField];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:separator];
    
    self.messageComposer = [[UITextView alloc]initWithFrame:CGRectMake(8, self.titleField.frame.size.height + 73, self.titleField.frame.size.width - 16, 100)];
    [self.view addSubview:self.messageComposer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) dismissView:(UIBarButtonItem*)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void) postUpdate:(UIBarButtonItem*)sender {
    NSLog(@"Posting!");
    PFObject *post = [[PFObject alloc]initWithClassName:@"post"];
    post[@"message"] = self.messageComposer.text;
    post[@"title"] = self.titleField.text;
    post[@"eventFBid"] = self.eventID;
    [post saveInBackground];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
