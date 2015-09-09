//
//  Created by Evgeniy Gurtovoy on 1/27/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APArrayCollectionViewDataSource.h"

static NSString *const APDummySupplementaryViewIdentifier = @"APDummySupplementaryViewIdentifier";

@interface APArrayCollectionViewDataSource ()


@property(weak, nonatomic) id <APArrayCollectionViewDataSourceDelegate> delegate;
@property(assign, nonatomic) BOOL dummySupplementaryViewRegistered;
@end



@implementation APArrayCollectionViewDataSource


#pragma mark - Init

- (instancetype)initWithObjects:(NSArray *)objects
                       delegate:(id <APArrayCollectionViewDataSourceDelegate>)delegate
{
    self = [super initWithItems:objects];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [[self objectsInSection:(NSUInteger) section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger sectionsCount = [self sectionsCount];
    if (! sectionsCount) {
        if ([self.delegate respondsToSelector:@selector(sectionHeaderReusableAtIndexPath:)] ||
            [self.delegate respondsToSelector:@selector(sectionFooterReusableAtIndexPath:)]) {
            return 1; // Fake section for display supplementary view
        }
    }
    return sectionsCount;
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
        if (! self.dummySupplementaryViewRegistered) {
            [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                      withReuseIdentifier:APDummySupplementaryViewIdentifier];
            self.dummySupplementaryViewRegistered = YES;
        }
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                          withReuseIdentifier:APDummySupplementaryViewIdentifier
                                                                 forIndexPath:indexPath];
    }
    return reusableView;
}

@end
