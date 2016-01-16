//
//  Created by Evgeniy Gurtovoy on 1/27/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APArrayDataSource.h"



@interface APArrayDataSource ()


@property(nonatomic, copy, readwrite) NSArray *items;
@end



@implementation APArrayDataSource


#pragma mark - Init

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.items = items;
    }
    return self;
}

- (instancetype)init
{
    return nil;
}

#pragma mark - APDataSource

- (NSArray *)objectsInSection:(NSUInteger)section
{
    if (section > 0) {
        [self throwMoreThanOneSectionException];
        return nil;
    }
    return self.items;
}

- (NSUInteger)allObjectsCount
{
    return [self.items count];
}

- (NSUInteger)sectionsCount
{
    return [self.items count] > 0 ? 1 : 0;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        [self throwMoreThanOneSectionException];
        return nil;
    }
    return self.items[(NSUInteger) indexPath.row];
}

- (NSIndexPath *)indexPathForObject:(id)object
{
    NSUInteger index = [self.items indexOfObjectIdenticalTo:object];
    return index == NSNotFound ? nil : [NSIndexPath indexPathForRow:index inSection:0];
}

#pragma mark - Private

- (void)throwMoreThanOneSectionException
{
    [NSException raise:NSInternalInconsistencyException
                format:@"%@ doesn't support more than 1 section!", NSStringFromClass([self class])];
}

@end
