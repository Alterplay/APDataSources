//
//  ZMLFRCCollectionViewDataSourceTests.m
//  Zoomlee
//
//  Created by Evgeniy Gurtovoy on 1/19/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ZMLFRCCollectionViewDataSource.h"
#import "NSFetchedResultsController+Additions.h"

@interface ZMLFRCCollectionViewDataSourceTests : XCTestCase
@property (nonatomic, strong) id collectionViewMock;
@property (nonatomic, strong) id fetchedResultsControllerMock;
@property (nonatomic, strong) id delegateMock;
@property (nonatomic, strong) ZMLFRCCollectionViewDataSource *collectionViewDataSource;
@end

@implementation ZMLFRCCollectionViewDataSourceTests

- (void)setUp
{
    [super setUp];
    self.collectionViewMock = [OCMockObject niceMockForClass:[UICollectionView class]];
    self.fetchedResultsControllerMock = [OCMockObject niceMockForClass:[NSFetchedResultsController class]];
    self.delegateMock = [OCMockObject mockForProtocol:@protocol(ZMLFRCCollectionViewDataSourceDelegate)];
}

- (void)tearDown
{
    self.collectionViewMock = nil;
    self.fetchedResultsControllerMock = nil;
    self.delegateMock = nil;
    self.collectionViewDataSource = nil;
    [super tearDown];
}

- (void)setupDataSource
{
    __block id collectionViewDataSource = nil;
    [[self.collectionViewMock expect] setDataSource:[OCMArg checkWithBlock:^BOOL(id obj) {
        collectionViewDataSource = obj;
        return YES;
    }]];
    __block id FRCDelegate = nil;
    [[self.fetchedResultsControllerMock expect] setDelegate:[OCMArg checkWithBlock:^BOOL(id obj) {
        FRCDelegate = obj;
        return YES;
    }]];
    [[self.collectionViewMock expect] registerClass:[UICollectionReusableView class]
                         forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                withReuseIdentifier:ZMLDummySupplementaryViewIdentifier];
    [[self.fetchedResultsControllerMock expect] performFetch:nil];
    self.collectionViewDataSource = [[ZMLFRCCollectionViewDataSource alloc] initWithCollectionView:self.collectionViewMock
                                                                          fetchedResultsController:self.fetchedResultsControllerMock
                                                                                          delegate:self.delegateMock];
}

- (void)testCollectionViewInitializer
{
    /* Expectations */
    __block id collectionViewDataSource = nil;
    [[self.collectionViewMock expect] setDataSource:[OCMArg checkWithBlock:^BOOL(id obj) {
        collectionViewDataSource = obj;
        return YES;
    }]];
    [[self.collectionViewMock expect] registerClass:[UICollectionReusableView class]
                         forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                withReuseIdentifier:ZMLDummySupplementaryViewIdentifier];
    
    /* Calls */
    self.collectionViewDataSource = [[ZMLFRCCollectionViewDataSource alloc] initWithCollectionView:self.collectionViewMock
                                                                          fetchedResultsController:nil
                                                                                          delegate:nil];
    
    /* Verifications */
    [self.collectionViewMock verify];
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
    self.collectionViewDataSource = [[ZMLFRCCollectionViewDataSource alloc] initWithCollectionView:nil
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
    self.collectionViewDataSource.paused = YES;
    
    /* Verifications */
    [self.fetchedResultsControllerMock verify];
}

- (void)testPausingDisabled
{
    /* Setup */
    [self setupDataSource];
    
    /* Expectations */
    id <NSFileManagerDelegate> delegate = self.collectionViewDataSource;
    [[self.fetchedResultsControllerMock expect] setDelegate:delegate];
    [[self.fetchedResultsControllerMock expect] performFetch:NULL];
    [[self.collectionViewMock expect] reloadData];
    
    /* Calls */
    self.collectionViewDataSource.paused = NO;
    
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
    NSInteger dataSourceObjectsCount = [self.collectionViewDataSource objectsCountInSection:0];
    
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
    NSArray *dataSourceObjects = [self.collectionViewDataSource objectsInSection:0];
    
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
    id objectAtIndexPath = [self.collectionViewDataSource objectAtIndexPath:indexPath];

    /* Expectations */
    expect(objectAtIndexPath).to.equal(objects[1]);
}

- (void)testCellForItemAtIndexPath
{
    /* Setup */
    [self setupDataSource];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [[[self.delegateMock stub] andReturnValue:OCMOCK_VALUE(@"reuseIdentifier")] cellReuseIdentifierForIndexPath:indexPath inDataSource:self.collectionViewDataSource];
    
    /* Expectations */
    [[self.delegateMock expect] configureCell:OCMOCK_ANY atIndexPath:indexPath withObject:OCMOCK_ANY];
    
    /* Calls */
    [self.collectionViewDataSource collectionView:nil cellForItemAtIndexPath:indexPath];
    
    /* Verifications */
    [self.delegateMock verify];
}

- (void)testFRCDidChangeContent
{
    /* Setup */
    [self setupDataSource];
    
    /* Expectations */
    [[self.collectionViewMock expect] reloadData];
    [[self.delegateMock expect] dataSourceDidChanged:self.collectionViewDataSource];
    
    /* Calls */
    [self.collectionViewDataSource controllerDidChangeContent:self.fetchedResultsControllerMock];
    
    /* Verifications */
    [self.collectionViewMock verify];
    [self.delegateMock verify];
}

@end
