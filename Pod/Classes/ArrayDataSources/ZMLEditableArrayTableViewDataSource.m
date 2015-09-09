//
//  Created by Sergii Kryvoblotskyi on 3/30/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "ZMLEditableArrayTableViewDataSource.h"



@implementation ZMLEditableArrayTableViewDataSource


- (instancetype)initWithItems:(NSArray *)items
                 allowEditing:(BOOL)allowEditing
{
    self = [super initWithItems:items];
    if (self) {
        _editingAllowed = allowEditing;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (BOOL)    tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editingAllowed;
}

- (BOOL)    tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editingAllowed;
}

- (void) tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.editingDelegate dataSourceMoveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

@end
