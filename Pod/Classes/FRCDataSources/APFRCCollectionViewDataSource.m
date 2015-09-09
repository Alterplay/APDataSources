//
//  Created by Evgeniy Gurtovoy on 1/15/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APFRCCollectionViewDataSource.h"



@interface APFRCCollectionViewDataSource ()


@property(weak, nonatomic) id <APFRCCollectionViewDataSourceDelegate> delegate;
@property(weak, nonatomic) UICollectionView *collectionView;
@end



@implementation APFRCCollectionViewDataSource


@synthesize paused = _paused;

#pragma mark - Init

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
              fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                              delegate:(id <APFRCCollectionViewDataSourceDelegate>)delegate
{
    self = [super initWithFetchedResultsController:fetchedResultsController];
    if (self) {
        _delegate = delegate;

        _collectionView = collectionView;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:APDummySupplementaryViewIdentifier];

        [fetchedResultsController performFetch:nil];
    }
    return self;
}

#pragma mark - Pausing

- (void)setPaused:(BOOL)paused
{
    _paused = paused;
    if (paused) {
        self.fetchedResultsController.delegate = nil;
    }
    else {
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:nil];
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController objectsInSection:section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self sectionsCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /* Request ReuseIdentifier */
    NSString *reuseIdentifier = self.cellReuseIdentifier;
    if ([self.delegate respondsToSelector:@selector(cellReuseIdentifierForIndexPath:inDataSource:)]) {
        reuseIdentifier = [self.delegate cellReuseIdentifierForIndexPath:indexPath inDataSource:self];
    }
    if (! reuseIdentifier) {
        [NSException raise:@"Invalid reuse identifier" format:@"Reuse identifier should not be nil"];
    }

    /* Dequeue cell */
    UICollectionViewCell <APCellProtocol> *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                                          forIndexPath:indexPath];

    /* Fetch object */
    id model = [self.fetchedResultsController objectAtIndexPath:indexPath];

    if ([self.delegate respondsToSelector:@selector(configureCell:atIndexPath:withObject:)]) {

        /* Custom cell configuration */
        [self.delegate configureCell:collectionViewCell atIndexPath:indexPath withObject:model];

    }
    else {

        /* Default cell configuration */
        [collectionViewCell reloadWithModel:model atIndexPath:indexPath];
    }

    return collectionViewCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;

    /* Ask delegate for ReusableView */
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if ([self.delegate respondsToSelector:@selector(sectionHeaderReusableAtIndexPath:)]) {
            reusableView = [self.delegate sectionHeaderReusableAtIndexPath:indexPath];
        }
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        if ([self.delegate respondsToSelector:@selector(sectionFooterReusableAtIndexPath:)]) {
            reusableView = [self.delegate sectionFooterReusableAtIndexPath:indexPath];
        }
    }

    if (! reusableView) {
        /* Dummy ReusableView */
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                          withReuseIdentifier:APDummySupplementaryViewIdentifier
                                                                 forIndexPath:indexPath];
    }

    return reusableView;
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView reloadData];

    /* Notify about changes if needed */
    if ([self.delegate respondsToSelector:@selector(dataSourceDidChanged:)]) {
        [self.delegate dataSourceDidChanged:self];
    }
}

@end
