//
//  Created by Evgeniy Gurtovoy on 1/27/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APDataSource.h"



@interface APArrayDataSource : NSObject <APDataSource>


/**
 *  Designated Initializer
 *
 *  @param items array
 *
 *  @return instance
 */
- (instancetype)initWithItems:(NSArray *)items NS_DESIGNATED_INITIALIZER;

/**
 *  Array of items
 */
@property(nonatomic, copy, readonly) NSArray *items;


@end



@interface APArrayDataSource (Unavailable)


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
