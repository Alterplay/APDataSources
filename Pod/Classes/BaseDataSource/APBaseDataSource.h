//
//  Created by Evgeniy Gurtovoy on 3/26/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APCellProtocol.h"
#import "APBaseDataSourceDelegate.h"



@interface APBaseDataSource : NSObject


/**
 *  Reuse Identifier for cell
 */
@property(nonatomic, copy) NSString *cellReuseIdentifier;

/**
 *  Count of objects
 *
 *  @return NSUInteger count
 */
- (NSUInteger)sectionsCount;

/**
 *  Array of objects in section
 *
 *  @param section number
 *
 *  @return NSArray
 */
- (NSArray *)objectsInSection:(NSUInteger)section;

/**
 *  object at indexPath
 *
 *  @param indexPath
 *
 *  @return id
 */
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  IndexPath for object
 *
 *  @param object id
 *
 *  @return NSIndexPath
 */
- (NSIndexPath *)indexPathForObject:(id)object;

@end
