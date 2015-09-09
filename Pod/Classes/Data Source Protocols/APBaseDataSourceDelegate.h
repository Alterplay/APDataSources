//
//  Created by Evgeniy Gurtovoy on 3/26/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APBaseDataSource;



@protocol APBaseDataSourceDelegate <NSObject>


@optional

/**
 *  Request custom cellReuseIdentifier for indexPath
 *
 *  Can be used for using different cells in different sections
 *
 *  @param indexPath  NSIndexPath UICollectionView/UITableView indexPath
 *  @param dataSource self instance
 *
 *  @return NSString reuseIdentifier
 */
- (NSString *)cellReuseIdentifierForIndexPath:(NSIndexPath *)indexPath
                                 inDataSource:(APBaseDataSource *)dataSource;

/**
 *  If method implemented, delegate can configurate cell at its discretion
 *
 *  Note: delegate should call reloadWithModel:atIndexPath: manually
 *
 *  @param listViewCell       UICollectionViewCell/UITableViewCell confirmed to protocol <APCellProtocol>
 *  @param indexPath          NSIndexPath UICollectionView/UITableView indexPath
 *  @param object             id
 */
- (void)configureCell:(id <APCellProtocol>)listViewCell
          atIndexPath:(NSIndexPath *)indexPath
           withObject:(id)object;

@end
