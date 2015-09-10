//
// Created by Nickolay Sheika on 10.09.15.
// Copyright (c) 2015 Nickolay Sheika. All rights reserved.
//

#import "APCoreDataCollectionViewController.h"
#import "APSimpleEntity.h"
#import "APCDController.h"
#import "APFRCCollectionViewDataSource.h"
#import "APSimpleCollectionViewCell.h"



@interface APCoreDataCollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong) APFRCCollectionViewDataSource *dataSource;
@end



@implementation APCoreDataCollectionViewController

#pragma mark - Accessors

- (NSManagedObjectContext *)mainContext
{
    return [APCDController defaultController].mainMOC;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupDataSource];
}

#pragma mark - Setup

- (void)setupDataSource
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([APSimpleEntity class])
                                                         inManagedObjectContext:self.mainContext];
    fetchRequest.entity = entityDescription;
    fetchRequest.fetchBatchSize = 20;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"city" ascending:YES];
    fetchRequest.sortDescriptors = @[ sortDescriptor ];

    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.mainContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];

    self.dataSource = [[APFRCCollectionViewDataSource alloc] initWithCollectionView:self.collectionView
                                                           fetchedResultsController:fetchedResultsController
                                                                cellReuseIdentifier:nil
                                                                           delegate:nil];
    self.dataSource.cellReuseIdentifier = [APSimpleCollectionViewCell reuseIdentifier];
}

#pragma mark - Actions

- (IBAction)addButtonTap:(id)sender
{
    APSimpleEntity *simpleEntity1 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([APSimpleEntity class])
                                                                  inManagedObjectContext:self.mainContext];
    simpleEntity1.city = @"New York";

    APSimpleEntity *simpleEntity2 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([APSimpleEntity class])
                                                                  inManagedObjectContext:self.mainContext];
    simpleEntity2.city = @"San Francisco";

    APSimpleEntity *simpleEntity3 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([APSimpleEntity class])
                                                                  inManagedObjectContext:self.mainContext];
    simpleEntity3.city = @"Los Angeles";

    [[APCDController defaultController] performSave];
}

@end