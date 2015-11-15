//
// Created by Nickolay Sheika on 18.03.15.
// Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APArrayDataSource.h"
#import "APTableViewCellFactory.h"



@interface APArrayTableViewDataSource : NSObject <UITableViewDataSource>


- (instancetype)initWithDataProvider:(id <APDataProvider>)dataProvider
                         cellFactory:(id <APTableViewCellFactory>)cellFactory NS_DESIGNATED_INITIALIZER;

@property(nonatomic, strong, readonly) id <APDataProvider> dataProvider;
@property(nonatomic, strong, readonly) id <APTableViewCellFactory> cellFactory;


@end



@interface APArrayTableViewDataSource (Unavailable)


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end