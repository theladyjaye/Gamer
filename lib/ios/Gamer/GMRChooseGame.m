//
//  GMRChooseGame.m
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRChooseGame.h"
#import "GMRChooseGame+SearchTableView.h"
#import "GMRChooseGame+TableView.h"
#import "GMRNavigationController.h"
#import "GMRGame.h"
#import "GMRMatch.h"
#import "GMRGameLobbyGlobals.h"
#import "GMRLabel.h"

@implementation GMRChooseGame
@synthesize gameLabel;

- (void)viewDidLoad 
{
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Game"];
	
	for(UIView * targetView in [self.navigationController.view subviews])
	{
		if([targetView class]== [UIImageView class])
		{
			navigationBarShadow = (UIImageView *)targetView;
		}
	}
	
	
	/*if(kFilters.game)	
	{
		gameLabel.text = kCreateMatchProgress.game.label;
		modesView.hidden = NO;
		
		if(kCreateMatchProgress.game.selectedMode > -1)
		{
			modeLabel.text          = [kCreateMatchProgress.game.modes objectAtIndex:kCreateMatchProgress.game.selectedMode];
			NSUInteger indexes[]    = {0, kCreateMatchProgress.game.selectedMode};
			
			NSIndexPath * indexPath = [NSIndexPath indexPathWithIndexes:indexes length:2];
			[modesTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
		}
	}
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"game" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	 */
	
	[super viewDidLoad];
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
	self.gameLabel = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.gameLabel = nil;
    [super dealloc];
}


@end
