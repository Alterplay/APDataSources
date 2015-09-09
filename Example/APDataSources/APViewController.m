//
//  APViewController.m
//  APDataSources
//
//  Created by Nickolay Sheika on 09/09/2015.
//  Copyright (c) 2015 Nickolay Sheika. All rights reserved.
//

#import "APViewController.h"
#import "APSimpleModel.h"


@interface APViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end



@implementation APViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    APSimpleModel *simpleModel1 = [APSimpleModel new];
    simpleModel1.city = @"New York";

    APSimpleModel *simpleModel2 = [APSimpleModel new];
    simpleModel2.city = @"San Francisco";

    APSimpleModel *simpleModel3 = [APSimpleModel new];
    simpleModel3.city = @"Los Angeles";

    [[APArrayTableViewDataSource alloc] init]
}

@end
