//
// Created by Nickolay Sheika on 10.09.15.
//

#import <Foundation/Foundation.h>



@protocol APDataSource <NSObject>


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