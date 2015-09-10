//
//  Created by Evgeniy Gurtovoy on 1/15/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APFRCDataSource.h"
#import "APUpdatableDataSourceDelegate.h"



@protocol APFRCCollectionViewDataSourceDelegate;



@interface APFRCCollectionViewDataSource : APFRCDataSource <UICollectionViewDataSource>


/**
 *  Designated initializer
 *
 *  @param collectionView           UICollectionView
 *  @param fetchedResultsController NSFetchedResultsController
 *  @param delegate                 <APFRCCollectionViewDataSourceDelegate> object
 *
 *  @return instance
 */
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
              fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                   cellReuseIdentifier:(NSString *)reuseIdentifier
                              delegate:(id <APFRCCollectionViewDataSourceDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/**
 *  Convenience initializer
 */
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
              fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                   cellReuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  Reuse identifier
 */
@property(nonatomic, copy) NSString *cellReuseIdentifier;

/**
 *  Delegate
 */
@property(weak, nonatomic) id <APFRCCollectionViewDataSourceDelegate> delegate;

/**
 *  Managed collection view
 */
@property(weak, nonatomic, readonly) UICollectionView *collectionView;


@end



@protocol APFRCCollectionViewDataSourceDelegate <APUpdatableDataSourceDelegate>


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

@interface APFRCCollectionViewDataSource (Unavailable)

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
