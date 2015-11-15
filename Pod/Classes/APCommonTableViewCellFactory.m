//
// Created by Nickolay Sheika on 14.11.15.
//

#import "APCommonTableViewCellFactory.h"



@interface APCommonTableViewCellFactory ()


@property(nonatomic, copy) CellConfigurator cellConfiguratorBlock;
@end



@implementation APCommonTableViewCellFactory


#pragma mark - Init

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithReuseIdentifier:reuseIdentifier cellConfigurator:nil];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
                       cellConfigurator:(CellConfigurator)cellConfiguratorBlock
{
    NSParameterAssert(reuseIdentifier);

    self = [super init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        self.cellConfiguratorBlock = cellConfiguratorBlock;
    }
    return self;
}

#pragma mark - APTableViewCellFactory

- (UITableViewCell *)cellForItem:(id)item
                     inTableView:(UITableView *)tableView
                     atIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier
                                                            forIndexPath:indexPath];
    if (self.cellConfiguratorBlock) {
        self.cellConfiguratorBlock(tableView, cell, item);
    }

    // for subclasses only
    [self configureCell:cell inTableView:tableView withModel:item];

    return cell;
}

#pragma mark - Subclasses

- (void)configureCell:(UITableViewCell *)cell
          inTableView:(UITableView *)tableView
            withModel:(id)model
{
    // abstract, for subclasses only
}

@end