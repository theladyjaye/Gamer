//
//  GMRGameDetailController.m
//  Gamer
//
//  Created by Adam Venturella on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRGameDetailController.h"
#import "GMRPlayersForMatch.h"

@implementation GMRGameDetailController
@synthesize tableView, playersForMatch;

- (void)viewDidLoad 
{	
	// cell height is set to 92 - Image components = 91 + 1 for seperator
	//tableView.separatorColor = [UIColor blackColor];

	//playersForMatch.maxPlayers = 0;
	[playersForMatch refresh:tableView];
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	tableView = nil;
}


- (void)dealloc {
	playersForMatch = nil;
    [super dealloc];
}


@end
