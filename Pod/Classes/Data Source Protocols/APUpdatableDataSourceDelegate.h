//
//  Created by Evgeniy Gurtovoy on 3/26/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APBaseDataSourceDelegate.h"

@protocol APDataSource;



@protocol APUpdatableDataSourceDelegate <APBaseDataSourceDelegate>


@optional

/**
 *  Notify delegate if content was changed
 *
 *  @param dataSource - self instance
 */
- (void)dataSourceDidChanged:(id <APDataSource>)dataSource;

/**
 *  Notifies the delegate about object deletion
 *
 *  @param dataSource
 *  @param object
 *  @param indexPath  
 */
- (void)dataSource:(id <APDataSource>)dataSource
   didDeleteObject:(id)object
       atIndexPath:(NSIndexPath *)indexPath;

@end
