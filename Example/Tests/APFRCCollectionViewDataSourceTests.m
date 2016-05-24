//
//  Created by Evgeniy Gurtovoy on 1/19/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APFRCCollectionViewDataSource.h"#import "OCMockObject.h"



@interface APFRCCollectionViewDataSourceTests : XCTestCase


#pragma mark - Mocks
@property(nonatomic, strong) id collectionViewMock;
@property(nonatomic, strong) id fetchedResultsControllerMock;
@property(nonatomic, strong) id delegateMock;

#pragma mark - SUT
@property(nonatomic, strong) APFRCCollectionViewDataSource *collectionViewDataSource;
@end



@implementation APFRCCollectionViewDataSourceTests

// TODO need refactor this

- (void)setUp
{
    [super setUp];
    self.collectionViewMock = [OCMockObject niceMockForClass:[UICollectionView class]];
    self.fetchedResultsControllerMock = [OCMockObject niceMockForClass:[NSFetchedResultsController class]];
    self.delegateMock = [OCMockObject mockForProtocol:@protocol(APFRCCollectionViewDataSourceDelegate)];
}

#pragma mark - Tests

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
//    [[self.collectionViewMock expect] registerClass:[UICollectionReusableView class]
//                         forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                                withReuseIdentifier:ZMLDummySupplementaryViewIdentifier];
    [[self.fetchedResultsControllerMock expect] performFetch:nil];
    self.collectionViewDataSource = [[APFRCCollectionViewDataSource alloc] initWithCollectionView:self.collectionViewMock
                                                                         fetchedResultsController:self.fetchedResultsControllerMock
                                                                              cellReuseIdentifier:nil
                                                                                         delegate:self.delegateMock];
    self.collectionViewDataSource.allowAnimatedUpdate = NO;
}

- (void)testCollectionViewInitializer
{
    /* Expectations */
    __block id collectionViewDataSource = nil;
    [[self.collectionViewMock expect] setDataSource:[OCMArg checkWithBlock:^BOOL(id obj) {
        collectionViewDataSource = obj;
        return YES;
    }]];
//    [[self.collectionViewMock expect] registerClass:[UICollectionReusableView class]
//                         forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                                withReuseIdentifier:ZMLDummySupplementaryViewIdentifier];

    /* Calls */
    self.collectionViewDataSource = [[APFRCCollectionViewDataSource alloc] initWithCollectionView:self.collectionViewMock
                                                                         fetchedResultsController:nil
                                                                              cellReuseIdentifier:nil
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
    self.collectionViewDataSource = [[APFRCCollectionViewDataSource alloc] initWithCollectionView:nil
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
    self.collectionViewDataSource.paused = YES;

    /* Verifications */
    [self.fetchedResultsControllerMock verify];
}

- (void)testPausingDisabled
{
    /* Setup */
    [self setupDataSource];

    /* Expectations */
    id delegate = self.collectionViewDataSource;
    [[self.fetchedResultsControllerMock expect] setDelegate:delegate];
    [[self.fetchedResultsControllerMock expect] performFetch:NULL];
    [[self.collectionViewMock expect] reloadData];

    /* Calls */
    self.collectionViewDataSource.paused = NO;

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
    id objectAtIndexPath = [self.collectionViewDataSource objectAtIndexPath:indexPath];

    /* Expectations */
    expect(objectAtIndexPath).to.equal(objects[1]);
}

- (void)testCellForItemAtIndexPath
{
    /* Setup */
    [self setupDataSource];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [[[self.delegateMock stub] andReturnValue:OCMOCK_VALUE(@"reuseIdentifier")] cellReuseIdentifierForIndexPath:indexPath
                                                                                                   inDataSource:self.collectionViewDataSource];

    /* Expectations */
    [[self.delegateMock expect] configureCell:[OCMArg any]
                                  atIndexPath:indexPath
                                    withModel:[OCMArg any]];

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
