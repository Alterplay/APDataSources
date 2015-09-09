//
// Created by Nickolay Sheika on 18.03.15.
// Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APArrayDataSource.h"



@interface APArrayTableViewDataSource : APArrayDataSource <UITableViewDataSource>


@property(nonatomic, weak) id <APBaseDataSourceDelegate> delegate;

@end