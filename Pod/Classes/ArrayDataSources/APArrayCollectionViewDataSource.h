//
//  Created by Evgeniy Gurtovoy on 1/27/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APArrayDataSource.h"



@protocol APArrayCollectionViewDataSourceDelegate;



@interface APArrayCollectionViewDataSource : APArrayDataSource <UICollectionViewDataSource>


- (instancetype)initWithObjects:(NSArray *)objects
                       delegate:(id <APArrayCollectionViewDataSourceDelegate>)delegate;

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
