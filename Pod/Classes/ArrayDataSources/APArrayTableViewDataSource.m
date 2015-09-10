//
// Created by Nickolay Sheika on 18.03.15.
// Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APDataSource.h"
#import "APArrayTableViewDataSource.h"
#import "APBaseDataSourceDelegate.h"
#import "APCellProtocol.h"



@interface APArrayTableViewDataSource ()


@property(nonatomic, copy, readwrite) NSArray *items;
@end



@implementation APArrayTableViewDataSource


#pragma mark - Init

- (instancetype)initWithItems:(NSArray *)items
          cellReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithItems:items
           cellReuseIdentifier:reuseIdentifier
                      delegate:nil];
}

- (instancetype)initWithItems:(NSArray *)items
          cellReuseIdentifier:(NSString *)reuseIdentifier
                     delegate:(id <APBaseDataSourceDelegate>)delegate
{
    self = [super initWithItems:items];
    if (self) {
        self.cellReuseIdentifier = reuseIdentifier;
        self.delegate = delegate;
    }
    return self;
}

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

    if ([self.delegate respondsToSelector:@selector(configureCell:atIndexPath:withModel:)]) {
        /* Custom cell configuration */
        [self.delegate configureCell:tableViewCell atIndexPath:indexPath withModel:model];
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