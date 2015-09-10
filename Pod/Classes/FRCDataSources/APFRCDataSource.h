//
//  Created by Evgeniy Gurtovoy on 1/21/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APBaseDataSource.h"
#import "APUpdatableDataSourceDelegate.h"
#import "NSFetchedResultsController+Additions.h"



@interface APFRCDataSource : APBaseDataSource <NSFetchedResultsControllerDelegate>


/**
 * Data source FetchedResultsController
 *
 * Should be settled in designated initializer
 *
 */
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


/**
 *  Pause/Resume observe changes in datasource
 */
@property(nonatomic, assign, getter = isPaused) BOOL paused;

/**
 *  Designated initializer
 *
 *  @param fetchedResultsController
 *
 *  @return instance
 */
- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;

/**
 *  Represents section at index
 *
 *  @param section NSInteger
 *
 *  @return id <NSFetchedResultsSectionInfo>
 */
- (id <NSFetchedResultsSectionInfo>)sectionAtIndex:(NSInteger)section;

/**
 *  Objects count based on 'numberOfObjects' property of the section info
 *
 *  @return NSUInteger real objects count, updated on FRC updates
 */
- (NSUInteger)objectsCount;

@end