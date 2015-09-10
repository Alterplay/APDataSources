//
//  Created by Nickolay Sheika on 18.03.15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <APDataSources/APCellProtocol.h>
#import <APDataSources/APBaseDataSourceDelegate.h>
#import "APArrayTableViewDataSource.h"
#import "OCMStubRecorder.h"
#import "OCMockObject.h"



@interface APArrayTableViewDataSourceTests : XCTestCase


#pragma mark - SUT
@property(nonatomic, strong) APArrayTableViewDataSource *dataSource;
@property(nonatomic, strong) APArrayTableViewDataSource *dataSourceEmpty;

#pragma mark - Mocks
@property(nonatomic, strong) id mockCellConfiguration;
@property(nonatomic, strong) id mockDelegate;
@property(nonatomic, strong) id mockTableView;

#pragma mark - Helpers
@property(nonatomic, strong) NSArray *fakeItems;
@property(nonatomic, strong) NSString *fakeCellIdentifier1;
@property(nonatomic, strong) NSString *fakeCellIdentifier2;
@end



@implementation APArrayTableViewDataSourceTests


- (void)setUp
{
    [super setUp];

    self.fakeItems = @[ @1, @4, @8, @8 ];
    self.fakeCellIdentifier1 = @"FakeCellIdentifier1";
    self.fakeCellIdentifier2 = @"FakeCellIdentifier2";

    self.dataSource = [[APArrayTableViewDataSource alloc] initWithItems:self.fakeItems];
    self.dataSource.cellReuseIdentifier = self.fakeCellIdentifier1;

    self.dataSourceEmpty = [[APArrayTableViewDataSource alloc] initWithItems:@[ ]];
    self.dataSourceEmpty.cellReuseIdentifier = self.fakeCellIdentifier1;

    self.mockCellConfiguration = [OCMockObject mockForProtocol:@protocol(APCellProtocol)];
    self.mockDelegate = [OCMockObject niceMockForProtocol:@protocol(APBaseDataSourceDelegate)];
    self.mockTableView = [OCMockObject mockForClass:[UITableView class]];
}

#pragma mark - Init

- (void)testInit
{
    expect([self.dataSource objectsInSection:0]).to.equal(self.fakeItems);
    expect([self.dataSourceEmpty objectsInSection:0]).to.haveCountOf(0);
}

#pragma mark - UITableViewDataSource

- (void)testNumberOfSections_ShouldReturnOneIfItemsIsNotEmpty
{
    expect([self.dataSource numberOfSectionsInTableView:self.mockTableView]).to.equal(1);
}

- (void)testNumberOfSections_ShouldReturnNullIfItemsIsEmpty
{
    expect([self.dataSourceEmpty numberOfSectionsInTableView:self.mockTableView]).to.equal(0);
}

- (void)testNumberOfRowsInSection_ShouldReturnItemsCount
{
    expect([self.dataSource tableView:self.mockTableView numberOfRowsInSection:0]).to.equal(4);
    expect([self.dataSourceEmpty tableView:self.mockTableView numberOfRowsInSection:0]).to.equal(0);
}

- (void)testNumberOfRowsInSection_ShouldThrowExceptionIfAskedForSecondSection
{
    expect(^{
        [self.dataSource tableView:self.mockTableView numberOfRowsInSection:1];
    }).to.raiseAny();
}

- (void)testCellForRowAtIndexPath_ShouldAskTableViewForCellAndConfigureCell
{
    // given
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    // expectations
    [[[self.mockTableView expect] andReturn:self.mockCellConfiguration] dequeueReusableCellWithIdentifier:self.fakeCellIdentifier1
                                                                                             forIndexPath:indexPath];
    [[self.mockCellConfiguration expect] reloadWithModel:self.fakeItems[0] atIndexPath:indexPath];

    // call
    [self.dataSource tableView:self.mockTableView cellForRowAtIndexPath:indexPath];

    // verifications
    [self.mockTableView verify];
    [self.mockCellConfiguration verify];
}

- (void)testCellForRowAtIndexPath_ShouldAskTableViewForCellAndConfigureCell_CustomDelegate
{
    // given
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [[[self.mockDelegate stub] andReturn:self.fakeCellIdentifier2] cellReuseIdentifierForIndexPath:indexPath
                                                                                      inDataSource:self.dataSource];
    self.dataSource.delegate = self.mockDelegate;

    // expectations
    [[[self.mockTableView expect] andReturn:self.mockCellConfiguration] dequeueReusableCellWithIdentifier:self.fakeCellIdentifier2
                                                                                             forIndexPath:indexPath];
    [[self.mockDelegate expect] configureCell:[OCMArg any]
                                  atIndexPath:indexPath
                                    withModel:self.fakeItems[2]];

    // call
    [self.dataSource tableView:self.mockTableView cellForRowAtIndexPath:indexPath];

    // verifications
    [self.mockTableView verify];
    [self.mockCellConfiguration verify];
}

- (void)testCellForRowAtIndexPath_ShouldThrowExceptionIfCellNotAdoptsConfigurationProtocol
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    [[[self.mockTableView stub] andReturn:[UITableViewCell new]] dequeueReusableCellWithIdentifier:self.fakeCellIdentifier1
                                                                                      forIndexPath:indexPath];
    expect(^{
        [self.dataSource tableView:self.mockTableView cellForRowAtIndexPath:indexPath];
    }).to.raiseAny();
}

@end
