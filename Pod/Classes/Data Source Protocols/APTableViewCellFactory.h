//
// Created by Nickolay Sheika on 14.11.15.
//

#import <Foundation/Foundation.h>



@protocol APTableViewCellFactory <NSObject>


- (UITableViewCell *)cellForItem:(id)item
                     inTableView:(UITableView *)tableView
                     atIndexPath:(NSIndexPath *)indexPath;
@end