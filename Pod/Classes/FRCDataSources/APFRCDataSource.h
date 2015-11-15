//
//  Created by Evgeniy Gurtovoy on 1/21/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "APDataProvider.h"



@interface APFRCDataSource : NSObject <APDataProvider, NSFetchedResultsControllerDelegate>


/**
 * Data source FetchedResultsController
 *
 * Should be set in designated initializer
 *
 */
@property(nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;


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
- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController NS_DESIGNATED_INITIALIZER;

/**
 *  Represents section at index
 *
 *  @param section NSInteger
 *
 *  @return id <NSFetchedResultsSectionInfo>
 */
- (id <NSFetchedResultsSectionInfo>)sectionAtIndex:(NSInteger)section;

@end



@interface APFRCDataSource (Unavailable)


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end