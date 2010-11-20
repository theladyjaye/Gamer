//
//  GMRGameDetailController+PlayerList.h
//  Gamer
//
//  Created by Adam Venturella on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRGameDetailController.h"

@interface GMRGameDetailController(PlayerList)<UITableViewDelegate, UITableViewDataSource>
- (void)playersTableRefresh;
@end
