//
//  GMRChoosePlatformController.m
//  Gamer
//
//  Created by Adam Venturella on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRChoosePlatformController.h"
#import "GMRMatch.h"
#import "GMRTypes.h"
#import "GMRCreateGameGlobals.h"
#import "GMRMenuButton.h"
#import "GMRLabel.h"

@implementation GMRChoosePlatformController
@synthesize platformBattleNet, platformPlaystation2, platformPlaystation3, platformSteam, platformWii, platformXBox360;

- (void)viewDidLoad 
{	
	// this is the override for child classes (eg: GMRAliasChoosePlatform)
	[self configure];
	[super viewDidLoad];
}

// designated override point for viewDidLoad for child classes
- (void)configure
{
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Platform"];
	
	if(kCreateMatchProgress.platform != GMRPlatformUnknown)
	{
		
		// when you come back we need to select your last selected button
		// so we need the button IBOutlets so we have something to target
		[self selectPlatform:kCreateMatchProgress.platform];
	}
}

- (IBAction)selectPlatformAction:(id)sender
{
	NSUInteger tag = [sender tag];
	switch(tag)
	{
		case 0: // Battle.Net
			kCreateMatchProgress.platform = GMRPlatformBattleNet;
			break;
			
		case 1: // Playstation 2
			kCreateMatchProgress.platform = GMRPlatformPlaystation2;
			break;
			
		case 2: // Playstation 3
			kCreateMatchProgress.platform = GMRPlatformPlaystation3;
			break;
			
		case 3: // Steam
			kCreateMatchProgress.platform = GMRPlatformSteam;
			break;
			
		case 4: // Wii
			kCreateMatchProgress.platform = GMRPlatformWii;
			break;
			
		case 5: // XBox 360
			kCreateMatchProgress.platform = GMRPlatformXBox360;
			break;
			
	}
	
	[self selectPlatform:kCreateMatchProgress.platform];
	
}

- (void)selectPlatform:(GMRPlatform)platform
{
	GMRMenuButton * target;
	
	switch(platform)
	{
		case GMRPlatformBattleNet:
			target = self.platformBattleNet;
			break;
		
		case GMRPlatformPlaystation2:
			target = self.platformPlaystation2;
			break;
		
		case GMRPlatformPlaystation3:
			target = self.platformPlaystation3;
			break;
			
		case GMRPlatformSteam:
			target = self.platformSteam;
			break;
		
		case GMRPlatformWii:
			target = self.platformWii;
			break;
		
		case GMRPlatformXBox360:
			target = self.platformXBox360;
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
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	selectedButton = nil;
	
	self.platformBattleNet = nil;
	self.platformPlaystation2 = nil;
	self.platformPlaystation3 = nil;
	self.platformSteam = nil;
	self.platformWii = nil;
	self.platformXBox360 = nil;
	
    [super dealloc];
}


@end
