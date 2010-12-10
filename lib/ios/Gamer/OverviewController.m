//
//  OverviewController.m
//  Gamer
//
//  Created by Adam Venturella on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverviewController.h"
#import "OverviewController+TableView.h"
#import "GMRGlobals.h"
#import "GMRCreateGameController.h"
#import "GMRLabel.h"
#import "UIButton+GMRButtonTypes.h"
#import "GMRNoneView.h"
#import "GMRMatchListCell.h"

@implementation OverviewController
@synthesize matchesTable, matches=kScheduledMatches;

-(void)createGame
{
	GMRCreateGameController * controller = [[GMRCreateGameController alloc] initWithNibName:nil
																					 bundle:nil];
	controller.matchesDataSourceController = self;
	
	UINavigationController * createGame    = [[UINavigationController alloc] initWithRootViewController:controller];
	
	UIImageView * navigationBarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBarBackgroundShadow.png"]];
	navigationBarShadow.frame         = CGRectMake(0, 64, 320.0, 9.0);
	
	[createGame.view addSubview:navigationBarShadow];
	[navigationBarShadow release];
	
	
	[self presentModalViewController:createGame 
							animated:YES];
	[createGame release];
	[controller release];
}

- (void)noMatchesScheduled
{
	noneView = [[GMRNoneView alloc] initWithLabel:@"No Scheduled Games."];
	[self.view addSubview:noneView];
	[noneView release];
}

- (void)viewDidLoad 
{		
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Scheduled"];
	
	UIButton * addMatchButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeAdd];
	[addMatchButton addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * addMatch = [[UIBarButtonItem alloc] initWithCustomView:addMatchButton];
	
	[self.navigationItem setRightBarButtonItem:addMatch animated:YES];
	[addMatch release];
	
	
	
	[self matchesTableRefresh];
	
	[self addObserver:self 
		         forKeyPath:@"matches" 
			        options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
			        context:nil];
	
	[super viewDidLoad];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSKeyValueChange kind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
	NSIndexSet * indexes  = [change objectForKey:NSKeyValueChangeIndexesKey];
	
	[matchesTable beginUpdates];
	
	switch(kind)
	{
		case NSKeyValueChangeInsertion:
			[matchesTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[indexes firstIndex] inSection:0]] 
								withRowAnimation:UITableViewRowAnimationNone];
			break;
		
		case NSKeyValueChangeRemoval:
			[matchesTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[indexes firstIndex] inSection:0]]  
								withRowAnimation:UITableViewRowAnimationNone];
			break;		
	}
	
	[matchesTable endUpdates];
	

}

- (void)updateCellsCountdown
{
	NSArray * cells = [matchesTable visibleCells];
	
	if([cells count] > 0)
	{
		for(GMRMatchListCell * cell in cells)
		{
			[cell setNeedsDisplay];
		}
		
		[matchesTable setNeedsDisplay];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self endCellUpdates];
}

- (void)viewDidAppear:(BOOL)animated
{
	[self updateCellsCountdown];
	[self beginCellUpdates];
	[matchesTable deselectRowAtIndexPath:[matchesTable indexPathForSelectedRow] animated:YES];
}

- (void)endCellUpdates
{
	[updateTimer invalidate];
	updateTimer = nil;
}

- (void)beginCellUpdates
{
	updateTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 
												   target:self 
								                 selector:@selector(updateCellsCountdown) 
								                 userInfo:nil 
									              repeats:YES];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.matchesTable = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [self removeObserver:self 
			  forKeyPath:@"matches"];
	
	[super dealloc];
}


@end
