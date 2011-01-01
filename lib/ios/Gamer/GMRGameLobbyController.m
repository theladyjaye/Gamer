//
//  GMRGameLobbyController.m
//  Gamer
//
//  Created by Adam Venturella on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRGameLobbyController.h"
#import "UIButton+GMRButtonTypes.h"
#import "GMRGameLobbyController+TableView.h"
#import "GMRLobbyFiltersController.h"
#import "GMRLabel.h"
#import "GMRTypes.h"
#import "GMRFilter.h"
#import "GMRNoneView.h"
#import "GMRMatchListCell.h"


@implementation GMRGameLobbyController
@synthesize filterCheveron, currentFilter,matchesTable, matches, matchListSourceUpdateViewOnChange;


- (void)viewDidLoad 
{
	
	// we will need this ViewController to be notified when the match list has been changed.
	matchListSourceUpdateViewOnChange = YES;
	
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Lobby"];
	
	UIImageView * navigationBarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBarBackgroundShadow.png"]];
	navigationBarShadow.frame         = CGRectMake(0, 64, 320.0, 9.0);
	
	[self.navigationController.view addSubview:navigationBarShadow];
	[navigationBarShadow release];
	
	UIButton * filtersButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeFilters];
	[filtersButton addTarget:self action:@selector(editLobbyFilters) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * filters = [[UIBarButtonItem alloc] initWithCustomView:filtersButton];
	
	[self.navigationItem setRightBarButtonItem:filters animated:NO];
	[filters release];
	
	
	filterCheveron.transform = CGAffineTransformMakeTranslation(-60,0);
	
	
	GMRFilter * filter = [[GMRFilter alloc] init];
	[self applyFilter:filter];
	[filter release];
	
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
	
	
	NSUInteger remaining = [matchesTable numberOfRowsInSection:0];
	
	if(remaining == 0)
	{
		[self noMatchesScheduled];
	}
	else if(noneView && remaining > 0)
	{
		[noneView removeFromSuperview];
		noneView = nil;
	}
	
}

- (void)editLobbyFilters
{
	 GMRLobbyFiltersController * controller = [[GMRLobbyFiltersController alloc] initWithNibName:nil
																						  bundle:nil];
	
	controller.owner = self;
	
	 UINavigationController * filterGames    = [[UINavigationController alloc] initWithRootViewController:controller];
	 
	 UIImageView * navigationBarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBarBackgroundShadow.png"]];
	 navigationBarShadow.frame         = CGRectMake(0, 64, 320.0, 9.0);
	 
	 [filterGames.view addSubview:navigationBarShadow];
	 [navigationBarShadow release];
	 
	 
	 [self presentModalViewController:filterGames 
							 animated:YES];
	 [filterGames release];
	 [controller release];
}

- (void)applyFilter:(GMRFilter *)filter
{
	if(![[filter description] isEqualToString:[currentFilter description]])
	{
		[currentFilter release];
		currentFilter = nil;
		currentFilter = filter;
		[filter retain];
		
		switch(filter.timeInterval)
		{
			case GMRTimeInterval15Min:
				[self translateCheveronX:-60];
				break;
				
			case GMRTimeInterval30Min:
				[self translateCheveronX:0];
				break;
				
			case GMRTimeIntervalHour:
				[self translateCheveronX:60];
				break;
		}
		
		[self resultsTableRefresh:currentFilter];
	}
}


- (IBAction)changeTimeFilter:(id)sender
{
	NSInteger tag = [sender tag];
	GMRFilter * filter;
	
	if(currentFilter)
	{
		filter = [GMRFilter filterWithFilter:currentFilter];
	}
	else 
	{
		filter = [[[GMRFilter alloc] init] autorelease];
	}

	
	switch(tag)
	{
		case 15:
			filter.timeInterval = GMRTimeInterval15Min;
			[self translateCheveronX:-60];
			break;
		
		case 30:
			[self translateCheveronX:0];
			filter.timeInterval = GMRTimeInterval30Min;
			break;
		
		case 60:
			[self translateCheveronX:60];
			filter.timeInterval = GMRTimeIntervalHour;
			break;
	}
	
	[self applyFilter:filter];
}

- (void)translateCheveronX:(CGFloat)tx
{
	[UIView animateWithDuration:0.2 
						  delay:0.0 
						options:UIViewAnimationCurveEaseOut 
					 animations:^{
						filterCheveron.transform = CGAffineTransformMakeTranslation(tx, 0); 
					 }
					 completion:NULL];
}

- (void)noMatchesScheduled
{
	if(!noneView)
	{
		[self endCellUpdates];
		
		noneView = [[GMRNoneView alloc] initWithLabel:@"No Scheduled Games."];
		noneView.showsArrow = NO;
		noneView.frame = (CGRect){{0.0, 33.0}, noneView.frame.size};
		[self.view addSubview:noneView];
		[noneView release];
		
		[self.matchesTable reloadData];
	}
}

- (void)endCellUpdates
{
	NSLog(@"killing timer");
	[updateTimer invalidate];
	updateTimer = nil;
}

- (void)beginCellUpdates
{
	// if more than 1 timer is applied this viewcontroller will not be able to be released. 
	if(!updateTimer)
	{
		NSLog(@"Wants Timer");
		if([matchesTable numberOfRowsInSection:0] > 0)
		{ 
			NSLog(@"Wants Got"); // TODO: need to test adding a cell and see if a timer gets scheduled after add
			[self updateCellsCountdown];
			updateTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 // matches JavaScript Interval
														   target:self 
														 selector:@selector(updateCellsCountdown) 
														 userInfo:nil 
														  repeats:YES];
		}
	}
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.filterCheveron = nil;
	self.matchesTable = nil;
}


- (void)dealloc {
	
	[self removeObserver:self 
			  forKeyPath:@"matches"];
	
	self.filterCheveron = nil;
	self.matchesTable = nil;
    
	[matches release];
	matches = nil;
	
	[currentFilter release];
	currentFilter = nil;
	
	[noneView release];
	noneView = nil;
	
	[super dealloc];
}


@end
