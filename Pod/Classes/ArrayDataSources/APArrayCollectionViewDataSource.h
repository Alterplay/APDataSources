//
//  Created by Evgeniy Gurtovoy on 1/27/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APArrayDataSource.h"
#import "APBaseDataSourceDelegate.h"


@protocol APArrayCollectionViewDataSourceDelegate;



@interface APArrayCollectionViewDataSource : APArrayDataSource <UICollectionViewDataSource>

/**
 *  Convenience initializers
 */
- (instancetype)initWithItems:(NSArray *)items
          cellReuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithItems:(NSArray *)items
          cellReuseIdentifier:(NSString *)reuseIdentifier
                     delegate:(id <APArrayCollectionViewDataSourceDelegate>)delegate;

/**
 *  Reuse identifier
 *
 *  Should be set before
 */
@property(nonatomic, copy) NSString *cellReuseIdentifier;

/**
 *  Delegate
 *
 *  Can be used to make custom cell configurations. Delegate methods always have more priority.
 */
@property(nonatomic, weak) id <APArrayCollectionViewDataSourceDelegate> delegate;

@end



@protocol APArrayCollectionViewDataSourceDelegate <APBaseDataSourceDelegate>


@optional

#pragma mark - Configuration

/**
 *  If method is described in delegate, delegate can configurate collectionReusableView for Header
 *
 *  @param indexPath NSIndexPath collectionView indexPath
 *
 *  @return UICollectionReusableView
 */
- (UICollectionReusableView *)sectionHeaderReusableAtIndexPath:(NSIndexPath *)indexPath;


/**
 *  If method is described in delegate, delegate can configurate collectionReusableView for Footer
 *
 *  @param indexPath NSIndexPath collectionView indexPath
 *
 *  @return UICollectionReusableView
 */
- (UICollectionReusableView *)sectionFooterReusableAtIndexPath:(NSIndexPath *)indexPath;

@end
