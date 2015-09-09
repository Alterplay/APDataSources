//
// Created by Nickolay Sheika on 09.09.15.
// Copyright (c) 2015 Nickolay Sheika. All rights reserved.
//

#import "APSimpleCollectionViewCell.h"
#import "APSimpleModel.h"



@interface APSimpleCollectionViewCell ()


@property(weak, nonatomic) IBOutlet UILabel *textLabel;


@end



@implementation APSimpleCollectionViewCell


+ (NSString *)reuseIdentifier
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