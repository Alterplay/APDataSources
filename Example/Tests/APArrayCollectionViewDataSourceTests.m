//
//  Created by Evgeniy Gurtovoy on 1/27/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APArrayCollectionViewDataSource.h"
#import "OCMockObject.h"



@interface APArrayCollectionViewDataSourceTests : XCTestCase


#pragma mark - Mocks
@property(nonatomic, strong) id delegateMock;

#pragma mark - Fake Data
@property(nonatomic, strong) NSArray *items;

#pragma mark - SUT
@property(nonatomic, strong) APArrayCollectionViewDataSource *dataSource;
@end



@implementation APArrayCollectionViewDataSourceTests

// TODO we need more tests!

- (void)setUp
{
    [super setUp];

    self.items = @[ @"1", @"2", @"3" ];
    self.delegateMock = [OCMockObject mockForProtocol:@protocol(APArrayCollectionViewDataSourceDelegate)];

    self.dataSource = [[APArrayCollectionViewDataSource alloc] initWithItems:self.items];
    self.dataSource.delegate = self.delegateMock;
}

#pragma mark - Tests

- (void)testReturnObjects
{
    /* Calls */
    NSArray *items = [self.dataSource objectsInSection:0];

    /* Expectations */
    expect(items).to.equal(self.items);
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
    [[[self.delegateMock stub] andReturnValue:OCMOCK_VALUE(@"reuseIdentifier")] cellReuseIdentifierForIndexPath:indexPath
                                                                                                   inDataSource:self.dataSource];

    /* Expectations */
    [[self.delegateMock expect] configureCell:[OCMArg any]
                                  atIndexPath:indexPath
                                    withModel:[OCMArg any]];

    /* Calls */
    [self.dataSource collectionView:nil cellForItemAtIndexPath:indexPath];

    /* Verifications */
    [self.delegateMock verify];
}

@end
