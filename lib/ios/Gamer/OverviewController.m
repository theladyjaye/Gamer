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

@implementation OverviewController
@synthesize matchesTable;

- (void)viewDidLoad 
{		
	// cell height is set to 92 - Image components = 91 + 1 for seperator
	matchesTable.separatorColor = [UIColor blackColor];
	[self matchesTableRefresh];
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
	self.matchesTable = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [matches release];
	[super dealloc];
}


@end
