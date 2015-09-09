//
//  Created by Evgeniy Gurtovoy on 1/27/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APArrayDataSource.h"



@interface APArrayDataSource ()


@property(nonatomic, strong) NSArray *items;
@end



@implementation APArrayDataSource


#pragma mark - Init

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        _items = [items copy];
    }
    return self;
}

#pragma mark - Public

- (NSArray *)objectsInSection:(NSUInteger)section
{
    if (section > 0) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"%@ doesn't support more than 1 section!", NSStringFromClass([self class])];
    }
    return self.items;
}

- (NSUInteger)sectionsCount
{
    return [self.items count] > 0 ? 1 : 0;
}

- (NSUInteger)objectsCountInSection:(NSUInteger)section
{
    return [[self objectsInSection:section] count];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[(NSUInteger) indexPath.row];
}

- (NSIndexPath *)indexPathForObject:(id)object
{
    NSUInteger index = [self.items indexOfObject:object];
    return index == NSNotFound ? nil : [NSIndexPath indexPathForRow:index inSection:0];
}

@end
