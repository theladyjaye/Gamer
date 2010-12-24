//
//  GMRGameLobbyController.h
//  Gamer
//
//  Created by Adam Venturella on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRViewController.h"


@class GMRFilter, GMRNoneView;
@interface GMRGameLobbyController : GMRViewController {
	UIImageView * filterCheveron;
	GMRFilter * currentFilter;
	NSMutableArray * matches;
	UITableView * matchesTable;
	GMRNoneView * noneView;
}
@property(nonatomic, readonly) GMRFilter * currentFilter;
@property(nonatomic, retain)IBOutlet UITableView * matchesTable;
@property(nonatomic, retain)IBOutlet UIImageView * filterCheveron;

- (IBAction)changeTimeFilter:(id)sender;
- (void)translateCheveronX:(CGFloat)tx;
- (void)editLobbyFilters;
- (void)applyFilter:(GMRFilter *)filter;
- (void)noMatchesScheduled;
@end
