//
//  GetHelpViewController.m
//  Popcorn
//
//  Created by Nate Parrott on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import "GetHelpViewController.h"
#import "AppDelegate.h"

@interface GetHelpViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic) IBOutlet UITextView *issue;
@property (nonatomic) IBOutlet UITextField *location;
@property (nonatomic) IBOutlet UIView *helpCard;
@property (nonatomic) IBOutlet UILabel *placeholder;
@property (nonatomic) IBOutlet UILabel *hintLabel;
@property (nonatomic) IBOutlet UIButton *dismissKeyboardButton;
@property (nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (nonatomic) BOOL keyboardVisible;
@property (nonatomic) BOOL loading;

@end

@implementation GetHelpViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.title = @"Help";
    self.tabBarItem.image = [UIImage imageNamed:@"help"];
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helpCard.layer.cornerRadius = 7;
    self.helpCard.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholder.hidden = self.issue.text.length > 0;
}

#pragma mark Keyboard
- (void)keyboardWillShow {
    self.keyboardVisible = YES;
}
- (void)keyboardWillHide {
    self.keyboardVisible = NO;
}
- (void)setKeyboardVisible:(BOOL)keyboardVisible {
    _keyboardVisible = keyboardVisible;
    [UIView animateWithDuration:0.3 animations:^{
        self.hintLabel.alpha = keyboardVisible ? 0 : 1;
        self.dismissKeyboardButton.alpha = keyboardVisible ? 1 : 0;
    }];
}
- (IBAction)dismissKeyboard:(id)sender {
    [self.issue resignFirstResponder];
    [self.location resignFirstResponder];
}

#pragma mark Requesting
- (IBAction)sendRequest:(id)sender {
    [self dismissKeyboard:nil];
    self.loading = YES;
    PFObject *req = [PFObject objectWithClassName:@"request"];
    [req setValue:self.location.text forKey:@"location"];
    [req setValue:self.issue.text forKey:@"message"];
    [req setValue:[FBSession activeSession].accessTokenData.userID forKey:@"fbid"];
    [req saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[self.event relationForKey:@"requests"] addObject:req];
        [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            self.loading = NO;
            [[[UIAlertView alloc] initWithTitle:@"Sent!" message:@"We'll get in touch ASAP!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
            self.issue.text = nil;
            self.location.text = nil;
        }];
    }];
}
- (void)setLoading:(BOOL)loading {
    _loading = loading;
    [AppDelegate shared].window.rootViewController.view.userInteractionEnabled = !loading;
    if (loading ) {
        [self.loader startAnimating];
    } else {
        [self.loader stopAnimating];
    }
}

@end
