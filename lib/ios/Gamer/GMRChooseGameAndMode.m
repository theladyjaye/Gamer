//
//  GMRChooseGameAndMode.m
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRChooseGameAndMode.h"
#import "GMRChooseGameAndMode+TableView.h"
#import "GMRChooseGameAndMode+SearchTableView.h"
#import "GMRGame.h"
#import "GMRMatch.h"
#import "GMRCreateGameGlobals.h"
#import "GMRLabel.h"

@implementation GMRChooseGameAndMode
@synthesize gameLabel, modeLabel, modesView, modesTableView;

//TODO: Use Gear Image for game mode cell (Player list cell with gear icon instead of the person icon)

- (void)viewDidLoad 
{
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Game and Mode"];
	
	if(kCreateMatchProgress.game)	
	{
		gameLabel.text = kCreateMatchProgress.game.label;
		modesView.hidden = NO;
		
		if(kCreateMatchProgress.game.selectedMode > -1)
		{
			modeLabel.text = [kCreateMatchProgress.game.modes objectAtIndex:kCreateMatchProgress.game.selectedMode];
		}
	}
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"game" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	[super viewDidLoad];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if([kCreateMatchProgress.game.modes count] > 0)
	{
		modesView.hidden = NO;
		
		[modesTableView reloadData];
		
		if([kCreateMatchProgress.game.modes count] < 7)
		{
			modesTableView.scrollEnabled = NO;
		}
	}
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
	self.gameLabel = nil;
	self.modeLabel = nil;
	self.modesView = nil;
	self.modesTableView = nil;
}


- (void)dealloc 
{
    [kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"game"];
	[games release];
	[super dealloc];
}


@end
