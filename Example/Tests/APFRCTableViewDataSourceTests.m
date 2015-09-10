//
//  Created by Evgeniy Gurtovoy on 1/21/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APFRCTableViewDataSource.h"



@interface APFRCTableViewDataSourceTests : XCTestCase


#pragma mark - Mocks
@property(nonatomic, strong) id tableViewMock;
@property(nonatomic, strong) id fetchedResultsControllerMock;
@property(nonatomic, strong) id delegateMock;

#pragma mark - SUT
@property(nonatomic, strong) APFRCTableViewDataSource *dataSource;
@end



@implementation APFRCTableViewDataSourceTests


// TODO need refactor this

- (void)setUp
{
    [super setUp];

    self.tableViewMock = [OCMockObject mockForClass:[UITableView class]];
    self.fetchedResultsControllerMock = [OCMockObject mockForClass:[NSFetchedResultsController class]];
    self.delegateMock = [OCMockObject mockForProtocol:@protocol(APFRCTableViewDataSourceDelegate)];
}

#pragma mark - Tests

- (void)testTableViewInitializer
{
    /* Expectations */
    __block id tableViewDataSource = nil;
    [[self.tableViewMock expect] setDataSource:[OCMArg checkWithBlock:^BOOL(id obj) {
        tableViewDataSource = obj;
        return YES;
    }]];

    /* Calls */
    self.dataSource = [[APFRCTableViewDataSource alloc] initWithTableView:self.tableViewMock
                                                 fetchedResultsController:nil
                                                      cellReuseIdentifier:nil
                                                                 delegate:nil];


    /* Verifications */
    [self.tableViewMock verify];
    [self.fetchedResultsControllerMock verify];
}

- (void)testFRCInitializer
{
    /* Expectations */
    __block id FRCDelegate = nil;
    [[self.fetchedResultsControllerMock expect] setDelegate:[OCMArg checkWithBlock:^BOOL(id obj) {
        FRCDelegate = obj;
        return YES;
    }]];
    [[self.fetchedResultsControllerMock expect] performFetch:nil];

    /* Calls */
    self.dataSource = [[APFRCTableViewDataSource alloc] initWithTableView:nil
                                                 fetchedResultsController:self.fetchedResultsControllerMock
                                                      cellReuseIdentifier:nil
                                                                 delegate:nil];

    /* Verifications */
    [self.fetchedResultsControllerMock verify];
}

- (void)testPausingEnabled
{
    /* Setup */
    [self setupDataSource];

    /* Expectations */
    [[self.fetchedResultsControllerMock expect] setDelegate:nil];

    /* Calls */
    self.dataSource.paused = YES;

    /* Verifications */
    [self.fetchedResultsControllerMock verify];
}

- (void)testPausingDisabled
{
    /* Setup */
    [self setupDataSource];

    /* Expectations */
    id delegate = self.dataSource;
    [[self.fetchedResultsControllerMock expect] setDelegate:delegate];
    [[self.fetchedResultsControllerMock expect] performFetch:NULL];
    [[self.tableViewMock expect] reloadData];

    /* Calls */
    self.dataSource.paused = NO;

    /* Verifications */
    [self.fetchedResultsControllerMock verify];
}

- (void)testObjectsAtIndexPath
{
    /* Setup */
    [self setupDataSource];
    NSArray *objects = @[ @(1), @(2), @(3) ];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];

    /* Expectations */
    [[[self.fetchedResultsControllerMock expect] andReturn:objects[1]] objectAtIndexPath:indexPath];

    /* Calls */
    id objectAtIndexPath = [self.dataSource objectAtIndexPath:indexPath];

    /* Expectations */
    expect(objectAtIndexPath).to.equal(objects[1]);
}

- (void)testCellForItemAtIndexPath
{
    /* Setup */
    [self setupDataSource];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [[[self.delegateMock stub] andReturnValue:OCMOCK_VALUE(@"reuseIdentifier")] cellReuseIdentifierForIndexPath:indexPath
                                                                                                   inDataSource:self.dataSource];

    /* Expectations */
    [[self.delegateMock expect] configureCell:[OCMArg any]
                                  atIndexPath:indexPath
                                    withModel:[OCMArg any]];
    [[self.fetchedResultsControllerMock expect] objectAtIndexPath:indexPath];

    /* Calls */
    [self.dataSource tableView:nil cellForRowAtIndexPath:indexPath];

    /* Verifications */
    [self.delegateMock verify];
}

- (void)testFRCWillChangeContentAnimationAllowed
{
    /* Setup */
    [self setupDataSource];

    /* Expectations */
    [[self.tableViewMock expect] beginUpdates];

    /* Calls */
    [self.dataSource controllerWillChangeContent:self.fetchedResultsControllerMock];

    /* Verifications */
    [self.tableViewMock verify];
}

- (void)testFRCWillChangeContentAnimationNotAllowed
{
    /* Setup */
    [self setupDataSource];
    self.dataSource.allowAnimatedUpdate = NO;

    /* Expectations */
    [[self.tableViewMock reject] beginUpdates];

    /* Calls */
    [self.dataSource controllerWillChangeContent:self.fetchedResultsControllerMock];

    /* Verifications */
    [self.tableViewMock verify];
}

- (void)testFRCDidChangeContentAnimationAllowed
{
    /* Setup */
    [self setupDataSource];

    /* Expectations */
    [[self.tableViewMock expect] endUpdates];
    [[self.tableViewMock reject] reloadData];
    [[self.delegateMock expect] dataSourceDidChanged:self.dataSource];

    /* Calls */
    [self.dataSource controllerDidChangeContent:self.fetchedResultsControllerMock];

    /* Verifications */
    [self.tableViewMock verify];
    [self.delegateMock verify];
}

- (void)testFRCDidChangeContentAnimationNotAllowed
{
    /* Setup */
    [self setupDataSource];
    self.dataSource.allowAnimatedUpdate = NO;

    /* Expectations */
    [[self.tableViewMock reject] endUpdates];
    [[self.tableViewMock expect] reloadData];
    [[self.delegateMock expect] dataSourceDidChanged:self.dataSource];

    /* Calls */
    [self.dataSource controllerDidChangeContent:self.fetchedResultsControllerMock];

    /* Verifications */
    [self.tableViewMock verify];
    [self.delegateMock verify];
}

#pragma mark - Helpers

- (void)setupDataSource
{
    __block id FRCDelegate = nil;
    [[self.fetchedResultsControllerMock expect] setDelegate:[OCMArg checkWithBlock:^BOOL(id obj) {
        FRCDelegate = obj;
        return YES;
    }]];
    __block id tableViewDataSource = nil;
    [[self.tableViewMock expect] setDataSource:[OCMArg checkWithBlock:^BOOL(id obj) {
        tableViewDataSource = obj;
        return YES;
    }]];
    [[self.fetchedResultsControllerMock expect] performFetch:nil];
    self.dataSource = [[APFRCTableViewDataSource alloc] initWithTableView:self.tableViewMock
                                                 fetchedResultsController:self.fetchedResultsControllerMock
                                                      cellReuseIdentifier:nil
                                                                 delegate:self.delegateMock];
}

@end
