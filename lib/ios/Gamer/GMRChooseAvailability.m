//
//  GMRChooseAvailability.m
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRChooseAvailability.h"
#import "GMRCreateGameGlobals.h"
#import "GMRMatch.h"

@implementation GMRChooseAvailability

- (void)viewDidLoad 
{
    self.navigationItem.title = @"Availability";
	[super viewDidLoad];
}


- (IBAction)selectPublic
{
	kCreateMatchProgress.availability = @"public";
	[self cancelSheet];
}

- (IBAction)selectPrivate
{
	kCreateMatchProgress.availability = @"private";
	[self cancelSheet];
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
}


- (void)dealloc {
    [super dealloc];
}


@end
