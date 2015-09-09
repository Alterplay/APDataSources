//
//  Created by Evgeniy Gurtovoy on 11/5/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import "NSFetchedResultsController+Additions.h"



@implementation NSFetchedResultsController (Additions)


- (NSArray *)objectsInSection:(NSInteger)section
{
    NSArray *sections = self.sections;
    id <NSFetchedResultsSectionInfo> firstSection = sections[(NSUInteger) section];
    return firstSection.objects;
}

@end
