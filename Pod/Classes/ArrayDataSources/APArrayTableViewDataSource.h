//
// Created by Nickolay Sheika on 18.03.15.
// Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APArrayDataSource.h"
#import <UIKit/UIKit.h>

@protocol APBaseDataSourceDelegate;



@interface APArrayTableViewDataSource : APArrayDataSource <UITableViewDataSource>

/**
 *  Convenience initializers
 */
- (instancetype)initWithItems:(NSArray *)items
          cellReuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithItems:(NSArray *)items
          cellReuseIdentifier:(NSString *)reuseIdentifier
                     delegate:(id <APBaseDataSourceDelegate>)delegate;


/**
 *  Reuse identifier
 */
@property(nonatomic, copy) NSString *cellReuseIdentifier;

/**
 *  Delegate
 *
 *  Can be used to make custom cell configurations. Delegate methods always have more priority.
 */
@property(nonatomic, weak) id <APBaseDataSourceDelegate> delegate;

@end