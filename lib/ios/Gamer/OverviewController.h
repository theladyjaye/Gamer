//
//  OverviewController.h
//  Gamer
//
//  Created by Adam Venturella on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRViewController.h"
#import "GMRMatchListSource.h"


@interface OverviewController : GMRViewController<GMRMatchListSource> {
	UITableView * matchesTable;
	UIView * noneView;
	NSTimer * updateTimer;
	BOOL matchListSourceUpdateViewOnChange;
}
@property(nonatomic, retain)IBOutlet UITableView * matchesTable;
@property(nonatomic, readonly)NSMutableArray * matches;
@property(nonatomic, readonly) BOOL matchListSourceUpdateViewOnChange;

- (void)createGame;
- (void)noMatchesScheduled;
- (void)beginCellUpdates;
- (void)endCellUpdates;
- (void)updateCellsCountdown;
@end
