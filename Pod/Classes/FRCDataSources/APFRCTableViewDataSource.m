//
//  Created by Evgeniy Gurtovoy on 1/15/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APFRCTableViewDataSource.h"



@implementation APFRCTableViewDataSource


@synthesize paused = _paused;

#pragma mark - Init

- (instancetype)initWithTableView:(UITableView *)tableView
         fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                         delegate:(id <APFRCTableViewDataSourceDelegate>)delegate
{
    self = [super initWithFetchedResultsController:fetchedResultsController];
    if (self) {
        _delegate = delegate;
        _allowAnimatedUpdate = YES;

        _tableView = tableView;
        _tableView.dataSource = self;

        [fetchedResultsController performFetch:nil];
    }
    return self;
}

+ (instancetype)dataSourceWithTableView:(UITableView *)tableView
               fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                               delegate:(id <APFRCTableViewDataSourceDelegate>)delegate
{
    return [[self alloc] initWithTableView:tableView
                  fetchedResultsController:fetchedResultsController
                                  delegate:delegate];
}

- (instancetype)initWithTableView:(UITableView *)tableView
         fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    self = [self initWithTableView:tableView
          fetchedResultsController:fetchedResultsController
                          delegate:nil];
    return self;
}


+ (instancetype)dataSourceWithTableView:(UITableView *)tableView
               fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    return [[self alloc] initWithTableView:tableView
                  fetchedResultsController:fetchedResultsController
                                  delegate:nil];
}

#pragma mark -
#pragma mark - Public
#pragma mark -

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
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
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
        [NSException raise:@"Invalid reuse identifier" format:@"Reuse identifier should not be nil"];
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
        [tableViewCell reloadWithModel:model atIndexPath:indexPath];
    }

    return tableViewCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self sectionsCount];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(headerTitleInSection:inDataSource:)]) {
        return [self.delegate headerTitleInSection:section inDataSource:self];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView
titleForFooterInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(footerTitleInSection:inDataSource:)]) {
        return [self.delegate footerTitleInSection:section inDataSource:self];
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(commitEditingStyle:forRowAtIndexPath:inDataSource:)]) {
        return [self.delegate commitEditingStyle:editingStyle forRowAtIndexPath:indexPath inDataSource:self];
    }
}

- (BOOL)    tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(canEditRowAtIndexPath:inDataSource:)]) {
        return [self.delegate canEditRowAtIndexPath:indexPath inDataSource:self];
    }

    return NO;
}

- (void) tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if ([self.delegate respondsToSelector:@selector(moveRowAtIndexPath:toIndexPath:inDataSource:)]) {
        return [self.delegate moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath inDataSource:self];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (self.allowAnimatedUpdate) {
        [self.tableView beginUpdates];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.allowAnimatedUpdate) {
        [self.tableView endUpdates];
    }
    else {
        [self.tableView reloadData];
    }

    /* Notify about changes if needed */
    if ([self.delegate respondsToSelector:@selector(dataSourceDidChanged:)]) {
        [self.delegate dataSourceDidChanged:self];
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    if (! self.allowAnimatedUpdate) {
        return;
    }
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (! self.allowAnimatedUpdate) {
        return;
    }
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            if ([self.delegate respondsToSelector:@selector(dataSource:didDeleteObject:atIndexPath:)]) {
                [self.delegate dataSource:self didDeleteObject:anObject atIndexPath:indexPath];
            }
        }
            break;
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        default:
            break;
    }
}

@end
