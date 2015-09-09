//
// Created by Nickolay Sheika on 18.03.15.
// Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APArrayTableViewDataSource.h"



@implementation APArrayTableViewDataSource


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self sectionsCount];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);
    return [[self objectsInSection:(NSUInteger) section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* Request ReuseIdentifier */
    NSString *reuseIdentifier = self.cellReuseIdentifier;
    if ([self.delegate respondsToSelector:@selector(cellReuseIdentifierForIndexPath:inDataSource:)]) {
        reuseIdentifier = [self.delegate cellReuseIdentifierForIndexPath:indexPath inDataSource:self];
    }

    if (! reuseIdentifier) {
        [NSException raise:NSInvalidArgumentException format:@"Reuse identifier should not be nil!"];
    }

    /* Dequeue cell */
    UITableViewCell <APCellProtocol> *tableViewCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                                                      forIndexPath:indexPath];
    /* Fetch object */
    id model = [self objectAtIndexPath:indexPath];

    if ([self.delegate respondsToSelector:@selector(configureCell:atIndexPath:withObject:)]) {
        /* Custom cell configuration */
        [self.delegate configureCell:tableViewCell atIndexPath:indexPath withObject:model];
    }
    else {
        /* Default cell configuration */
        if ([tableViewCell respondsToSelector:@selector(reloadWithModel:atIndexPath:)]) {
            [tableViewCell reloadWithModel:model atIndexPath:indexPath];
        }
        else {
            [NSException raise:NSInternalInconsistencyException
                        format:@"Cell should adopt protocol APCellProtocol for successful configuration with model"];
        }
    }
    return tableViewCell;
}

@end