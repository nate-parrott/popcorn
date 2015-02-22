//
//  FeedTableViewController.m
//  Popcorn
//
//  Created by Jessica Liang on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import "FeedTableViewController.h"
#import "FeedCardView.h"
#import "UpdateComposerViewController.h"
#import "AppDelegate.h"
#import "EventTableViewController.h"

@interface FeedTableViewController ()

@end

@implementation FeedTableViewController

- (instancetype) initWithStyle:(UITableViewStyle)style event:(PFObject *)event isStaff:(BOOL) staff {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"back"
                                   style: UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(dismissView:)];
    self.navigationItem.leftBarButtonItem = backButton;
    

    [self.tableView setBackgroundColor:[UIColor grayColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self = [super initWithStyle:style];
    self.event = event;
    self.tabBarItem.image = [UIImage imageNamed:@"news"];
    self.isStaff = staff;
    PFQuery *postQuery = [PFQuery queryWithClassName:@"post"];
    [postQuery whereKey:@"eventFBid" equalTo:self.event[@"fbid"]];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.posts = [NSMutableArray arrayWithArray:objects];
            NSLog(@"%@", objects);
            [self.tableView reloadData];
        } else {
            NSLog(@"Error loading post objects");
        }
    }];
    return self;
}
- (void) dismissView:(UIBarButtonItem*)sender {
    EventTableViewController *event = [[EventTableViewController alloc] initWithStyle:UITableViewStylePlain];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = event;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (self.isStaff) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0 && self.isStaff) {
        return 1;
    } else {
        return [self.posts count];
    }
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.isStaff) {
        NSLog(@"lets bring up the composer!");
        UpdateComposerViewController *composer = [[UpdateComposerViewController alloc] initWithEventID:self.event[@"fbid"]];
        UINavigationController *composerNav = [[UINavigationController alloc] initWithRootViewController:composer];
        [composer setTitle:@"Composer!"];
        composer.completionBlock = ^(PFObject * newPost) {
            [self.posts insertObject:newPost atIndex:0];
            [self.tableView reloadData];
        };
        [self presentViewController:composerNav animated:YES completion:^{
            
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        return 50;
    }
    PFObject *post = [self.posts objectAtIndex:[indexPath row]];
    return [FeedCardView heighForPost:post] + 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0 && self.isStaff) {
        [cell.textLabel setText:@"Send an update!"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    } else {
        PFObject *post = [self.posts objectAtIndex:[indexPath row]];
        FeedCardView *cardView = [[FeedCardView alloc] initWithPost:post andFrame:CGRectMake(8, 8, self.view.frame.size.width - 16, [FeedCardView heighForPost:post])];
        [cell.contentView addSubview:cardView];
    }
    [cell setBackgroundColor:[UIColor grayColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
