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
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Platform"];
	
	if(kCreateMatchProgress.platform != GMRPlatformUnknown)
	{
		[self selectPlatform:kCreateMatchProgress.platform];
	}
	
	[super viewDidLoad];
}

- (IBAction)selectPlatformAction:(id)sender
{
	if(sender != selectedButton)
	{
		if(sender == platformBattleNet)
		{
			kCreateMatchProgress.platform = GMRPlatformBattleNet;
		}
		else if(sender == platformPlaystation2)
		{
			kCreateMatchProgress.platform = GMRPlatformPlaystation2;
		}
		else if(sender == platformPlaystation3)
		{
			kCreateMatchProgress.platform = GMRPlatformPlaystation3;
		}
		else if(sender == platformSteam)
		{
			kCreateMatchProgress.platform = GMRPlatformSteam;
		}
		else if(sender == platformWii)
		{
			kCreateMatchProgress.platform = GMRPlatformWii;
		}
		else if (sender == platformXBox360)
		{
			kCreateMatchProgress.platform = GMRPlatformXBox360;
		}
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
	self.platformBattleNet = nil;
	self.platformPlaystation2 = nil;
	self.platformPlaystation3 = nil;
	self.platformSteam = nil;
	self.platformWii = nil;
	self.platformXBox360 = nil;
    [super dealloc];
}


@end
