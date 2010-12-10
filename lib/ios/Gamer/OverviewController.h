//
//  OverviewController.h
//  Gamer
//
//  Created by Adam Venturella on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRViewController.h"
@interface OverviewController : GMRViewController {
	UITableView * matchesTable;
	NSMutableArray * matches;
	UIView * noneView;
	NSTimer * updateTimer;
}
@property(nonatomic, retain)IBOutlet UITableView * matchesTable;
@property(nonatomic, readonly)NSMutableArray * matches;

- (void)createGame;
- (void)noMatchesScheduled;
- (void)beginCellUpdates;
- (void)endCellUpdates;
- (void)updateCellsCountdown;
@end
