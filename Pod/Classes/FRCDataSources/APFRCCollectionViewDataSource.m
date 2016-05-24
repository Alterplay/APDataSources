//
//  Created by Evgeniy Gurtovoy on 1/15/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APFRCCollectionViewDataSource.h"

static NSString *const APDummySupplementaryViewIdentifier = @"APDummySupplementaryViewIdentifier";



@implementation APFRCCollectionViewDataSource

#pragma mark - Init

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
              fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                   cellReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithCollectionView:collectionView
               fetchedResultsController:fetchedResultsController
                    cellReuseIdentifier:reuseIdentifier
                               delegate:nil];
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
              fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                   cellReuseIdentifier:(NSString *)reuseIdentifier
                              delegate:(id <APFRCCollectionViewDataSourceDelegate>)delegate
{
    self = [super initWithFetchedResultsController:fetchedResultsController];
    if (self) {
        _delegate = delegate;
        _cellReuseIdentifier = reuseIdentifier;
        _allowAnimatedUpdate = YES;

        _collectionView = collectionView;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:APDummySupplementaryViewIdentifier];

        [fetchedResultsController performFetch:nil];
    }
    return self;
}

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    return nil;
}

#pragma mark - Pausing

- (void)setPaused:(BOOL)paused
{
    [super setPaused:paused];
    if (paused) {
        self.fetchedResultsController.delegate = nil;
    }
    else {
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:nil];
        [self reloadData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [[self objectsInSection:(NSUInteger) section] count];
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
    id model = [self objectAtIndexPath:indexPath];

    if ([self.delegate respondsToSelector:@selector(configureCell:atIndexPath:withModel:)]) {
        /* Custom cell configuration */
        [self.delegate configureCell:collectionViewCell atIndexPath:indexPath withModel:model];
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

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self reloadData];

    /* Notify about changes if needed */
    if ([self.delegate respondsToSelector:@selector(dataSourceDidChanged:)]) {
        [self.delegate dataSourceDidChanged:self];
    }
}

#pragma mark - Reload  

- (void)reloadData
{
    if (self.allowAnimatedUpdate) {
        void (^updates)() = ^{
            NSInteger sectionsCount = [self.collectionView numberOfSections];
            NSIndexSet *sections = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, (NSUInteger) sectionsCount)];
            [self.collectionView reloadSections:sections];
        };
        [self.collectionView performBatchUpdates:updates completion:nil];
    }
    else {
        [self.collectionView reloadData];
    }
}

@end
