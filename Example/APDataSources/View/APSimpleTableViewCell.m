//
// Created by Nickolay Sheika on 09.09.15.
// Copyright (c) 2015 Nickolay Sheika. All rights reserved.
//

#import "APSimpleTableViewCell.h"
#import "APSimpleModel.h"



@implementation APSimpleTableViewCell


+ (NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}

#pragma mark - APCellProtocol

- (void)reloadWithModel:(APSimpleModel *)model
            atIndexPath:(NSIndexPath *)indexPath
{
    self.textLabel.text = model.city;
}


@end