//
//  Created by Evgeniy Gurtovoy on 1/21/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APFRCDataSource.h"



@implementation APFRCDataSource


#pragma mark - Init

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    self = [super init];
    if (self) {
        _fetchedResultsController = fetchedResultsController;
        _fetchedResultsController.delegate = self;
    }
    return self;
}

#pragma mark - Public

- (id <NSFetchedResultsSectionInfo>)sectionAtIndex:(NSInteger)section
{
    return self.fetchedResultsController.sections[(NSUInteger) section];
}

- (NSArray *)objectsInSection:(NSUInteger)section
{
    return [self.fetchedResultsController objectsInSection:section];
}

- (NSUInteger)sectionsCount
{
    return [self.fetchedResultsController.sections count];
}

- (NSUInteger)objectsCount
{
    NSUInteger sectionsCount = [self.fetchedResultsController.sections count];
    NSUInteger objectsCount = 0;
    for (NSInteger i = 0; i < sectionsCount; i ++) {
        id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[(NSUInteger) i];
        objectsCount += [sectionInfo numberOfObjects];
    }

    return objectsCount;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForObject:(id)object
{
    return [self.fetchedResultsController indexPathForObject:object];
}

@end
