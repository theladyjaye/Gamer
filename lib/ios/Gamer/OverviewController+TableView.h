//
//  OverviewController+TableView.h
//  Gamer
//
//  Created by Adam Venturella on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OverviewController.h"
@interface OverviewController(TableView)<UITableViewDataSource, UITableViewDelegate>
- (void)matchesTableRefresh;
@end
