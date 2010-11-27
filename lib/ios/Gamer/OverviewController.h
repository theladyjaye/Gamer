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
}
@property(nonatomic, retain)IBOutlet UITableView * matchesTable;

-(IBAction)createGame;
@end
