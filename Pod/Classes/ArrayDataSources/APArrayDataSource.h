//
//  Created by Evgeniy Gurtovoy on 1/27/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APBaseDataSource.h"



@interface APArrayDataSource : APBaseDataSource


/**
 *  Designated Initializer
 *
 *  @param items array
 *
 *  @return instance
 */
- (instancetype)initWithItems:(NSArray *)items;

@end
