//
// Created by Nickolay Sheika on 09.09.15.
// Copyright (c) 2015 Nickolay Sheika. All rights reserved.
//

#import <APDataSources/APArrayCollectionViewDataSource.h>
#import "APArrayCollectionViewController.h"
#import "APSimpleModel.h"
#import "APSimpleCollectionViewCell.h"



@interface APArrayCollectionViewController () <UICollectionViewDelegateFlowLayout>


@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong) APArrayCollectionViewDataSource *dataSource;
@end



@implementation APArrayCollectionViewController


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

    self.dataSource = [[APArrayCollectionViewDataSource alloc] initWithItems:items];
    self.dataSource.cellReuseIdentifier = [APSimpleCollectionViewCell reuseIdentifier];
    self.collectionView.dataSource = self.dataSource;
}

@end