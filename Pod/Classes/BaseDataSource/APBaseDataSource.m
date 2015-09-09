//
//  Created by Evgeniy Gurtovoy on 3/26/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import "APBaseDataSource.h"



@implementation APBaseDataSource


- (NSUInteger)sectionsCount
{
    return 0;
}

- (NSUInteger)objectsCountInSection:(NSUInteger)section
{
    return 0;
}

- (NSArray *)objectsInSection:(NSUInteger)section
{
    return nil;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSIndexPath *)indexPathForObject:(id)object
{
    return nil;
}

@end
