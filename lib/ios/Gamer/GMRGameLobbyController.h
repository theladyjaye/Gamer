//
//  GMRGameLobbyController.h
//  Gamer
//
//  Created by Adam Venturella on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRViewController.h"
#import "GMRMatchListSource.h"

@class GMRFilter, GMRNoneView;
@interface GMRGameLobbyController : GMRViewController<GMRMatchListSource> {
	UIImageView * filterCheveron;
	GMRFilter * currentFilter;
	NSMutableArray * matches;
	UITableView * matchesTable;
	GMRNoneView * noneView;
	NSTimer * updateTimer;
	BOOL matchListSourceUpdateViewOnChange;
}
@property(nonatomic, readonly) GMRFilter * currentFilter;
@property(nonatomic, readonly) NSMutableArray * matches;
@property(nonatomic, retain)IBOutlet UITableView * matchesTable;
@property(nonatomic, retain)IBOutlet UIImageView * filterCheveron;
@property(nonatomic, readonly) BOOL matchListSourceUpdateViewOnChange;


- (IBAction)changeTimeFilter:(id)sender;
- (void)translateCheveronX:(CGFloat)tx;
- (void)editLobbyFilters;
- (void)applyFilter:(GMRFilter *)filter;
- (void)noMatchesScheduled;
- (void)beginCellUpdates;
- (void)endCellUpdates;
- (void)updateCellsCountdown;
@end
