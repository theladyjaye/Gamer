//
//  GMRGameDetailController.m
//  Gamer
//
//  Created by Adam Venturella on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRGameDetailController.h"
#import "GMRGameDetailController+PlayerList.h"

@implementation GMRGameDetailController
@synthesize playersTableView, playersForMatch;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super initWithNibName:nil bundle:nil];
	if(self)
	{
		match = dictionary;
		[match retain];
	}
	
	return self;
}
- (void)viewDidLoad 
{	
	// cell height is set to 92 - Image components = 91 + 1 for seperator
	//tableView.separatorColor = [UIColor blackColor];

	//playersForMatch.maxPlayers = 0;
	self.navigationItem.title = @"Match Detail";
	[self playersTableRefresh];
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
	self.playersTableView = nil;
}


- (void)dealloc {
	self.playersForMatch = nil;
	[match release];
    [super dealloc];
}


@end
