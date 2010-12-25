//
//  GMRChooseTimeInterval.m
//  Gamer
//
//  Created by Adam Venturella on 12/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRChooseTimeInterval.h"
#import "GMRLabel.h"
#import "GMRGameLobbyGlobals.h"
#import "GMRFilter.h"
#import "GMRMenuButton.h"
#import "GMRTypes.h"

@implementation GMRChooseTimeInterval
@synthesize interval15Min, interval30Min, intervalHour;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Starting Within"];
	
	if(kFilters.timeInterval)
	{
		// when you come back we need to select your last selected button
		// so we need the button IBOutlets so we have something to target
		[self intervalSelected:kFilters.timeInterval];
	}
	
	[super viewDidLoad];
}

- (IBAction)selectInterval:(id)sender
{
	NSUInteger tag = [sender tag];
	switch(tag)
	{
		case 15: // 15 min
			kFilters.timeInterval = GMRTimeInterval15Min;
			break;
			
		case 30: // 30 min
			kFilters.timeInterval = GMRTimeInterval30Min;
			break;
			
		case 60: // 1 hour
			kFilters.timeInterval = GMRTimeIntervalHour;
			break;			
	}
	
	[self intervalSelected:kFilters.timeInterval];
	
}

- (void)intervalSelected:(GMRTimeInterval)timeInterval
{
	GMRMenuButton * target;
	
	switch(timeInterval)
	{
		case GMRTimeInterval15Min:
			target = self.interval15Min;
			break;
			
		case GMRTimeInterval30Min:
			target = self.interval30Min;
			break;
			
		case GMRTimeIntervalHour:
			target = self.intervalHour;
			break;
	}
	
	if(selectedButton != target)
	{
		if(selectedButton)
			selectedButton.selected = NO;
		
		selectedButton = target;
		selectedButton.selected = YES;
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
    self.interval15Min = nil;
	self.interval30Min = nil;
	self.intervalHour = nil;
}


- (void)dealloc 
{
    selectedButton = nil;
	self.interval15Min = nil;
	self.interval30Min = nil;
	self.intervalHour = nil;
	
	[super dealloc];
}


@end
