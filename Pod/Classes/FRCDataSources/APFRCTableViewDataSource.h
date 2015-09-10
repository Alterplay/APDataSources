//
//  Created by Evgeniy Gurtovoy on 1/15/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APFRCDataSource.h"
#import "APUpdatableDataSourceDelegate.h"

@protocol APFRCTableViewDataSourceDelegate;



@interface APFRCTableViewDataSource : APFRCDataSource <UITableViewDataSource>


/**
 *  Reuse identifier
 */
@property(nonatomic, copy) NSString *cellReuseIdentifier;

/**
*  Delegate
*/
@property(weak, nonatomic) id <APFRCTableViewDataSourceDelegate> delegate;

/**
*  Table View
*/
@property(weak, nonatomic, readonly) UITableView *tableView;

/**
*  Update TableView animated (default is YES)
*/
@property(nonatomic, assign) BOOL allowAnimatedUpdate;

/**
*  Designated initializer
*
*  @param tableView                UITableView
*  @param fetchedResultsController NSFetchedResultsController
*  @param delegate                 <APFRCTableViewDataSourceDelegate> object
*
*  @return instance
*/
- (instancetype)initWithTableView:(UITableView *)tableView
         fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
              cellReuseIdentifier:(NSString *)reuseIdentifier
                         delegate:(id <APFRCTableViewDataSourceDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/**
*  Convenience initializer. Delegate should be set manually
*
*  @param tableView                UITableView
*  @param fetchedResultsController NSFetchedResultsController
*
*  @return instance
*/
- (instancetype)initWithTableView:(UITableView *)tableView
         fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
              cellReuseIdentifier:(NSString *)reuseIdentifier;

@end



@protocol APFRCTableViewDataSourceDelegate <APUpdatableDataSourceDelegate>


@optional

#pragma mark - Configuration

/**
*  If method is described in delegate, delegate can configurate header title
*
*  @param section
*  @param dataSource
*
*  @return header title
*/
- (NSString *)headerTitleInSection:(NSInteger)section
                      inDataSource:(APFRCTableViewDataSource *)dataSource;

/**
*  If method is described in delegate, delegate can configurate footer title
*
*  @param section    NSInteger
*  @param dataSource APFRCTableViewDataSource instance
*
*  @return footer title
*/
- (NSString *)footerTitleInSection:(NSInteger)section
                      inDataSource:(APFRCTableViewDataSource *)dataSource;

#pragma mark - Editing table

/**
 *  Forwarded UITableViewDataSource method to get row editing availability
 *
 *  @param indexPath    NSIndexPath                 index path editing status is required for
 *  @param dataSource   APFRCTableViewDataSource   datasource required editing info
 *
 *  @return BOOL YES if editing allowed
 */
- (BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath
                 inDataSource:(APFRCTableViewDataSource *)dataSource;

/**
 *  Forwarded UITableViewDataSource method
 *
 *  @param editingStyle UITableViewCellEditingStyle received from UITableViewDataSource
 *  @param indexPath    NSIndexPath index path for editing cell
 *  @param dataSource   APFRCTableViewDataSource datasource
 */
- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
         forRowAtIndexPath:(NSIndexPath *)indexPath
              inDataSource:(APFRCTableViewDataSource *)dataSource;

/**
 *  Forwarded UITableViewDataSource method
 *
 *  @param sourceIndexPath      NSIndexPath
 *  @param destinationIndexPath NSIndexPath
 *  @param dataSource   APFRCTableViewDataSource datasource
 */
- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
               toIndexPath:(NSIndexPath *)destinationIndexPath
              inDataSource:(APFRCTableViewDataSource *)dataSource;

@end



@interface APFRCTableViewDataSource (Unavailable)


- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


@end
