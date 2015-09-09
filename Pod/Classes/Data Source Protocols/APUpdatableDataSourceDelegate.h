//
//  Created by Evgeniy Gurtovoy on 3/26/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol APUpdatableDataSourceDelegate <APBaseDataSourceDelegate>


@optional

/**
 *  Notify delegate if content was changed
 *
 *  @param dataSource - self instance
 */
- (void)dataSourceDidChanged:(id)dataSource;

/**
 *  Notifies the delegate about object deletion
 *
 *  @param dataSource d
 *  @param object
 *  @param indexPath  
 */
- (void)dataSource:(id)dataSource
   didDeleteObject:(id)object
       atIndexPath:(NSIndexPath *)indexPath;

@end
