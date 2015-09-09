//
//  Created by Evgeniy Gurtovoy on 1/15/15.
//  Copyright (c) 2015 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol APCellProtocol <NSObject>


@required
- (void)reloadWithModel:(id)model
            atIndexPath:(NSIndexPath *)indexPath;
@end
