//
//  EventTableViewController.m
//  Popcorn
//
//  Created by Jessica Liang on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import "EventTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "EventTabBarViewController.h"
#import "AppDelegate.h"

@interface EventTableViewController ()

@end

@implementation EventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FBRequestConnection startWithGraphPath:@"/me/events"
                                 parameters: @{@"since": @(0.1), @"fields":@"owner, name,venue"}
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              
                              self.events = [result valueForKey:@"data"];
                              [self.tableView reloadData];
                          }];
    

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
                             
    // Configure the cell...
    [cell.textLabel setText:[[self.events objectAtIndex:[indexPath row]] valueForKey:@"name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *event = self.events[indexPath.row];
    PFQuery *queryExistingEvent = [PFQuery queryWithClassName:@"event"];
    [queryExistingEvent whereKey:@"fbid" equalTo:event[@"id"]];
    [queryExistingEvent findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFObject *parseEvent = objects.firstObject;
        if (!parseEvent) {
            parseEvent = [PFObject objectWithClassName:@"event" dictionary:@{
                                                                        @"fbid": event[@"id"],
                                                                        @"staffFbids": @[event[@"owner"][@"id"]]
                                                                        }];
            if (event[@"venue"] && [event[@"venue"] isKindOfClass:[NSDictionary class]] && event[@"venue"][@"latitude"]) {
                CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([event[@"venue"][@"latitude"] doubleValue], [event[@"venue"][@"longitude"] doubleValue]);
                [parseEvent setValue:[PFGeoPoint geoPointWithLatitude:loc.latitude longitude:loc.longitude] forKey:@"mapCenter"];
                [parseEvent setValue:@1000 forKey:@"mapRadius"];
            }
            [parseEvent saveInBackground];
        }
        EventTabBarViewController *tabs = [[EventTabBarViewController alloc] initWithEvent:parseEvent];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController = tabs;
    }];
    
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
