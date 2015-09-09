//
//  APArrayTableViewController.m
//  APDataSources
//
//  Created by Nickolay Sheika on 09/09/2015.
//  Copyright (c) 2015 Nickolay Sheika. All rights reserved.
//

#import <APDataSources/APArrayTableViewDataSource.h>
#import "APArrayTableViewController.h"
#import "APSimpleModel.h"
#import "APSimpleTableViewCell.h"



@interface APArrayTableViewController ()


@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) APArrayTableViewDataSource *dataSource;
@end



@implementation APArrayTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    APSimpleModel *simpleModel1 = [APSimpleModel new];
    simpleModel1.city = @"New York";

    APSimpleModel *simpleModel2 = [APSimpleModel new];
    simpleModel2.city = @"San Francisco";

    APSimpleModel *simpleModel3 = [APSimpleModel new];
    simpleModel3.city = @"Los Angeles";

    NSArray *items = @[ simpleModel1, simpleModel2, simpleModel3 ];

    self.dataSource = [[APArrayTableViewDataSource alloc] initWithItems:items];
    self.dataSource.cellReuseIdentifier = [APSimpleTableViewCell reuseIdentifier];
    self.tableView.dataSource = self.dataSource;
}

@end
