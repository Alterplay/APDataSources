//
// Created by Nickolay Sheika on 09.09.15.
// Copyright (c) 2015 Nickolay Sheika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <APDataSources/APCellProtocol.h>



@interface APSimpleTableViewCell : UITableViewCell <APCellProtocol>


+ (NSString *)reuseIdentifier;
@end