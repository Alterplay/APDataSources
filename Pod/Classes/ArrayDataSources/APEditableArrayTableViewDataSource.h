//
//  Created by Sergii Kryvoblotskyi on 3/30/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APArrayTableViewDataSource.h"

@protocol APEditableArrayTableViewDataSourceDelegate;



@interface APEditableArrayTableViewDataSource : APArrayTableViewDataSource


/**
 *  Instantaites datasource with items and editing mode
 *
 *  @param items        NSArray
 *  @param allowEditing BOOL
 *
 *  @return APEditableArrayTableViewDataSource
 */
- (instancetype)initWithItems:(NSArray *)items
                 allowEditing:(BOOL)allowEditing;

@property(nonatomic, weak) id <APEditableArrayTableViewDataSourceDelegate> editingDelegate;
@property(nonatomic, readonly) BOOL editingAllowed;

@end



@protocol APEditableArrayTableViewDataSourceDelegate <NSObject>


/**
 *  Notifies the delegate about rows moving
 *
 *  @param sourceIndexPath      NSIndexPath
 *  @param destinationIndexPath NSIndexPath
 */
- (void)dataSourceMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
                         toIndexPath:(NSIndexPath *)destinationIndexPath;

@end
