//
//  ZMLArrayCollectionViewDataSourceTests.m
//  Zoomlee
//
//  Created by Evgeniy Gurtovoy on 1/27/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "ZMLArrayCollectionViewDataSource.h"

@interface ZMLArrayCollectionViewDataSourceTests : XCTestCase
@property (nonatomic, strong) id delegateMock;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) ZMLArrayCollectionViewDataSource *dataSource;
@end

@implementation ZMLArrayCollectionViewDataSourceTests

- (void)setUp
{
    [super setUp];
    self.items = @[@"1", @"2", @"3"];
    self.delegateMock = [OCMockObject mockForProtocol:@protocol(ZMLArrayCollectionViewDataSourceDelegate)];
    self.dataSource = [[ZMLArrayCollectionViewDataSource alloc] initWithObjects:self.items
                                                                       delegate:self.delegateMock];
}

- (void)tearDown
{
    self.items = nil;
    self.delegateMock = nil;
    self.dataSource = nil;
    [super tearDown];
}


- (void)testReturnObjects
{
    /* Calls */
    NSArray *items = [self.dataSource objectsInSection:0];
    
    /* Expectations */
    expect(items).to.equal(self.items);
}

- (void)testReturnObjectsCount
{
    /* Calls */
    NSInteger count = [self.dataSource objectsCountInSection:0];
 
    /* Expectations */
    expect(self.items.count).to.equal(count);
}

- (void)testObjectAtIndex
{
    /* Calls */
    id object = [self.dataSource objectAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    /* Expectations */
    expect(object).to.equal(@"2");
}

- (void)testIndexOfObject
{
    /* Calls */
    NSIndexPath *objectIndexPath1 = [self.dataSource indexPathForObject:@"2"];
    NSIndexPath *objectIndexPath100 = [self.dataSource indexPathForObject:@"100"];
    
    /* Expectations */
    expect(objectIndexPath1.row).to.equal(1);
    expect(objectIndexPath100).to.beNil();
}

- (void)testCellForItemAtIndexPath
{
    /* Setup */
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [[[self.delegateMock stub] andReturnValue:OCMOCK_VALUE(@"reuseIdentifier")] cellReuseIdentifierForIndexPath:indexPath inDataSource:self.dataSource];
    
    /* Expectations */
    [[self.delegateMock expect] configureCell:OCMOCK_ANY atIndexPath:indexPath withObject:OCMOCK_ANY];
    
    /* Calls */
    [self.dataSource collectionView:nil cellForItemAtIndexPath:indexPath];
    
    /* Verifications */
    [self.delegateMock verify];
}

@end
