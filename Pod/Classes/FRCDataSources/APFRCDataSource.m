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

#pragma mark - APDataSource

- (NSArray *)objectsInSection:(NSUInteger)section
{
    id <NSFetchedResultsSectionInfo> theSection = self.fetchedResultsController.sections[(NSUInteger) section];
    return theSection.objects;
}

- (NSUInteger)sectionsCount
{
    return [self.fetchedResultsController.sections count];
}

- (NSUInteger)allObjectsCount
{
    return [self.fetchedResultsController.sections.valueForKeyPath:@"@sum.numberOfObjects"];
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
