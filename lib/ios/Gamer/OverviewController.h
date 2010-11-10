//
//  OverviewController.h
//  Gamer
//
//  Created by Adam Venturella on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRDataSource.h"

@class ScheduledMatchesData;
@interface OverviewController : UIViewController<UITableViewDelegate, UITableViewDelegate> {
	UITableView * tableView;
	NSObject<GMRDataSource> * dataProvider;
}
@property(nonatomic, retain)IBOutlet UITableView * tableView;
@property(nonatomic, retain)IBOutlet NSObject<GMRDataSource> * dataProvider;

@end
