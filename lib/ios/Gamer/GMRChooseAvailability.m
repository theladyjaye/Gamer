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
#import "GMRMenuButton.h"
#import "GMRTypes.h"

@implementation GMRChooseAvailability
@synthesize availabilityPublic, availabilityPrivate;

- (void)viewDidLoad 
{
    self.navigationItem.title = @"Availability";
	
	if(kCreateMatchProgress.availability != GMRMatchAvailabliltyUnknown)
	{
		[self selectAvailability:kCreateMatchProgress.availability];
	}
	
	[super viewDidLoad];
}


- (IBAction)selectAvailabilityAction:(id)sender
{
	if(sender != selectedAvailability)
	{
		NSInteger tag = [sender tag];
		
		switch(tag)
		{
			case 0: // Public
				kCreateMatchProgress.availability = GMRMatchAvailabliltyPublic;
				break;
			
			case 1: // Private
				kCreateMatchProgress.availability = GMRMatchAvailabliltyPrivate;
				break;
		}
		
		[self selectAvailability:kCreateMatchProgress.availability];
	}
}

- (void)selectAvailability:(GMRMatchAvailablilty)value
{
	GMRMenuButton * target;
	
	switch(value)
	{
		case GMRMatchAvailabliltyPublic:
			target = self.availabilityPublic;
			break;
		
		case GMRMatchAvailabliltyPrivate:
			target = self.availabilityPrivate;	
			break;
			
	}	
	
	if(selectedAvailability != target)
	{
		if(selectedAvailability)
			selectedAvailability.selected = NO;
		
		selectedAvailability = target;
		selectedAvailability.selected = YES;
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
}


- (void)dealloc {
	self.availabilityPublic = nil;
	self.availabilityPrivate = nil;
    [super dealloc];
}


@end
