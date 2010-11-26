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

@implementation GMRChooseGameAndMode
@synthesize gameLabel, modeLabel;

- (void)viewDidLoad 
{
    self.navigationItem.title = @"Game and Mode";
	
	if(kCreateMatchProgress.game)	
	{
		gameLabel.text = kCreateMatchProgress.game.label;
		
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
	NSLog(@"GAME SELECTED!");
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
}


- (void)dealloc 
{
    [kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"game"];

	[games release];
	[super dealloc];
}


@end
