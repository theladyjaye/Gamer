//
//  GMRProfileController.h
//  Gamer
//
//  Created by Adam Venturella on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRViewController.h"

@interface GMRProfileController : GMRViewController {
	UINavigationBar * navigationBar;
	NSMutableArray * aliases;
	UITableView * aliasTableView;
}
@property(nonatomic, retain) IBOutlet UINavigationBar * navigationBar;
@property(nonatomic, retain) IBOutlet UITableView * aliasTableView;

- (void)addAlias;
- (IBAction) performAction:(id)sender;

@end
