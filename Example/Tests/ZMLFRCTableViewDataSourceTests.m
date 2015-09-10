//
//  ZMLFRCTableViewDataSourceTests.m
//  Zoomlee
//
//  Created by Evgeniy Gurtovoy on 1/21/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ZMLFRCTableViewDataSource.h"
#import "NSFetchedResultsController+Additions.h"

@interface ZMLFRCTableViewDataSourceTests : XCTestCase
@property (nonatomic, strong) id tableViewMock;
@property (nonatomic, strong) id fetchedResultsControllerMock;
@property (nonatomic, strong) id delegateMock;
@property (nonatomic, strong) ZMLFRCTableViewDataSource *tableViewDataSource;
@end

@implementation ZMLFRCTableViewDataSourceTests

- (void)setUp
{
    [super setUp];
    self.tableViewMock = [OCMockObject mockForClass:[UITableView class]];
    self.fetchedResultsControllerMock = [OCMockObject mockForClass:[NSFetchedResultsController class]];
    self.delegateMock = [OCMockObject mockForProtocol:@protocol(ZMLFRCTableViewDataSourceDelegate)];
}

- (void)tearDown
{
    self.tableViewMock = nil;
    self.fetchedResultsControllerMock = nil;
    self.delegateMock = nil;
    self.tableViewDataSource = nil;
    [super tearDown];
}

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
    self.tableViewDataSource = [[ZMLFRCTableViewDataSource alloc] initWithTableView:self.tableViewMock
                                                           fetchedResultsController:self.fetchedResultsControllerMock
                                                                           delegate:self.delegateMock];
}

- (void)testTableViewInitializer
{
    /* Expectations */
    __block id tableViewDataSource = nil;
    [[self.tableViewMock expect] setDataSource:[OCMArg checkWithBlock:^BOOL(id obj) {
        tableViewDataSource = obj;
        return YES;
    }]];
    
    /* Calls */
    self.tableViewDataSource = [[ZMLFRCTableViewDataSource alloc] initWithTableView:self.tableViewMock
                                                           fetchedResultsController:nil
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
    self.tableViewDataSource = [[ZMLFRCTableViewDataSource alloc] initWithTableView:nil
                                                           fetchedResultsController:self.fetchedResultsControllerMock
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
    self.tableViewDataSource.paused = YES;
    
    /* Verifications */
    [self.fetchedResultsControllerMock verify];
}

- (void)testPausingDisabled
{
    /* Setup */
    [self setupDataSource];
    
    /* Expectations */
    id <NSFileManagerDelegate> delegate = self.tableViewDataSource;
    [[self.fetchedResultsControllerMock expect] setDelegate:delegate];
    [[self.fetchedResultsControllerMock expect] performFetch:NULL];
    [[self.tableViewMock expect] reloadData];
    
    /* Calls */
    self.tableViewDataSource.paused = NO;
    
    /* Verifications */
    [self.fetchedResultsControllerMock verify];
}

- (void)testObjectsCountInSection
{
    /* Setup */
    [self setupDataSource];
    NSArray *dataSourceObjects = @[@"", @"", @""];
    
    /* Expectations */
    [[[self.fetchedResultsControllerMock expect] andReturn:dataSourceObjects] objectsInSection:0];
    
    /* Calls */
    NSInteger dataSourceObjectsCount = [self.tableViewDataSource objectsCountInSection:0];
    
    /* Expectations */
    expect(dataSourceObjectsCount).to.equal(dataSourceObjects.count);
}

- (void)testObjectsInSection
{
    /* Setup */
    [self setupDataSource];
    NSArray *objects = @[@"", @"", @""];
    
    /* Expectations */
    [[[self.fetchedResultsControllerMock expect] andReturn:objects] objectsInSection:0];
    
    /* Calls */
    NSArray *dataSourceObjects = [self.tableViewDataSource objectsInSection:0];
    
    /* Expectations */
    expect(dataSourceObjects).to.equal(objects);
}

- (void)testObjectsAtIndexPath
{
    /* Setup */
    [self setupDataSource];
    NSArray *objects = @[@(1), @(2), @(3)];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    
    /* Expectations */
    [[[self.fetchedResultsControllerMock expect] andReturn:objects[1]] objectAtIndexPath:indexPath];
    
    /* Calls */
    id objectAtIndexPath = [self.tableViewDataSource objectAtIndexPath:indexPath];
    
    /* Expectations */
    expect(objectAtIndexPath).to.equal(objects[1]);
}

- (void)testCellForItemAtIndexPath
{
    /* Setup */
    [self setupDataSource];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [[[self.delegateMock stub] andReturnValue:OCMOCK_VALUE(@"reuseIdentifier")] cellReuseIdentifierForIndexPath:indexPath inDataSource:self.tableViewDataSource];
    
    /* Expectations */
    [[self.delegateMock expect] configureCell:OCMOCK_ANY atIndexPath:indexPath withObject:OCMOCK_ANY];
    [[self.fetchedResultsControllerMock expect] objectAtIndexPath:indexPath];
    
    /* Calls */
    [self.tableViewDataSource tableView:nil cellForRowAtIndexPath:indexPath];
    
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
    [self.tableViewDataSource controllerWillChangeContent:self.fetchedResultsControllerMock];
    
    /* Verifications */
    [self.tableViewMock verify];
}

- (void)testFRCWillChangeContentAnimationNotAllowed
{
    /* Setup */
    [self setupDataSource];
    self.tableViewDataSource.allowAnimatedUpdate = NO;
    
    /* Expectations */
    [[self.tableViewMock reject] beginUpdates];
    
    /* Calls */
    [self.tableViewDataSource controllerWillChangeContent:self.fetchedResultsControllerMock];
    
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
    [[self.delegateMock expect] dataSourceDidChanged:self.tableViewDataSource];
    
    /* Calls */
    [self.tableViewDataSource controllerDidChangeContent:self.fetchedResultsControllerMock];
    
    /* Verifications */
    [self.tableViewMock verify];
    [self.delegateMock verify];
}

- (void)testFRCDidChangeContentAnimationNotAllowed
{
    /* Setup */
    [self setupDataSource];
    self.tableViewDataSource.allowAnimatedUpdate = NO;
    
    /* Expectations */
    [[self.tableViewMock reject] endUpdates];
    [[self.tableViewMock expect] reloadData];
    [[self.delegateMock expect] dataSourceDidChanged:self.tableViewDataSource];
    
    /* Calls */
    [self.tableViewDataSource controllerDidChangeContent:self.fetchedResultsControllerMock];
    
    /* Verifications */
    [self.tableViewMock verify];
    [self.delegateMock verify];
}

@end
