//
// Created by Nickolay Sheika on 14.11.15.
//

#import <Foundation/Foundation.h>
#import "APTableViewCellFactory.h"

typedef void (^CellConfigurator)(UITableViewCell *cell, id model);



@interface APCommonTableViewCellFactory : NSObject <APTableViewCellFactory>


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
                       cellConfigurator:(CellConfigurator)cellConfiguratorBlock NS_DESIGNATED_INITIALIZER;


@property(nonatomic, copy, readonly) NSString *reuseIdentifier;

@end



// for subclasses only
@interface APCommonTableViewCellFactory (Subclasses)


- (void)configureCell:(UITableViewCell *)cell
            withModel:(id)model;

@end