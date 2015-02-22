//
//  RequestTableViewController.m
//  Popcorn
//
//  Created by Nate Parrott on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import "RequestTableViewController.h"
#import "RequestTableViewCell.h"

@interface RequestTableViewController ()

@property (nonatomic) NSArray *requests;

@end

@implementation RequestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(reload)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload];
}

- (void)reload {
    [[[self.event relationForKey:@"requests"] query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.requests = objects;
        [self.refreshControl endRefreshing];
    }];
}

- (void)setRequests:(NSArray *)requests {
    _requests = requests;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.requests.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Request" forIndexPath:indexPath];
    cell.request = self.requests[indexPath.section];
    return cell;
}

@end
