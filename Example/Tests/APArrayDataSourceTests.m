//
//  APArrayDataSourceTests.m
//  APDataSources
//
//  Created by Nickolay Sheika on 10.09.15.
//  Copyright (c) 2015 Nickolay Sheika. All rights reserved.
//

#import "APArrayDataSource.h"

@interface APArrayDataSourceTests : XCTestCase

#pragma mark - SUT
@property(nonatomic, strong) APArrayDataSource *dataSource;

#pragma mark - Fake Data
@property(nonatomic, strong) NSArray *items;
@end



@implementation APArrayDataSourceTests


- (void)setUp
{
    [super setUp];

    self.items = @[@1, @4, @8, @8];

    self.dataSource = [[APArrayDataSource alloc] initWithItems:self.items];
}

#pragma mark - Tests

- (void)testInit
{
    APArrayDataSource *dataSource = [[APArrayDataSource alloc] initWithItems:self.items];
    expect(dataSource).toNot.beNil();
    expect(dataSource.items).to.equal(self.items);
}

- (void)testSectionsCount
{
    NSUInteger sectionsCount = [self.dataSource sectionsCount];
    expect(sectionsCount).to.equal(1);
}

- (void)testAllObjectsCount
{
    NSUInteger allObjectsCount = [self.dataSource allObjectsCount];
    expect(allObjectsCount).to.equal([self.items count]);
}

- (void)testObjectsInSection_ReturnsCorrectForFirstSection
{
    NSArray *objects = [self.dataSource objectsInSection:0];
    expect(objects).to.equal(self.items);
}

- (void)testObjectsInSection_ThrowsExceptionForNotFirstSection
{
    expect(^{
        [self.dataSource objectsInSection:1];
    }).to.raiseAny();
}

- (void)testObjectAtIndexPath_ReturnsCorrectForFirstSection
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    id object = [self.dataSource objectAtIndexPath:indexPath];
    expect(object).to.equal(@4);
}

- (void)testObjectAtIndexPath_ThrowsExceptionForNotFirstSection
{
    expect(^{
        [self.dataSource objectAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    }).to.raiseAny();
}

- (void)testIndexPathForObject
{
    id object = self.items[1];
    NSIndexPath *indexPath = [self.dataSource indexPathForObject:object];
    expect(indexPath.row).to.equal(1);
    expect(indexPath.section).to.equal(0);
}

@end
