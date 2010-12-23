    //
//  GMRLobbyFiltersChoosePlatform.m
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRLobbyFiltersChoosePlatform.h"
#import "GMRLabel.h"
#import "GMRGameLobbyGlobals.h"
#import "GMRFilter.h"

@implementation GMRLobbyFiltersChoosePlatform

- (void)configure
{
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Platform"];
	
	if(kFilters.platform != GMRPlatformUnknown)
	{
		
		// when you come back we need to select your last selected button
		// so we need the button IBOutlets so we have something to target
		[self selectPlatform:kFilters.platform];
	}
}

- (IBAction)selectPlatformAction:(id)sender
{
	NSUInteger tag = [sender tag];
	
	switch(tag)
	{
		case 0: // Battle.Net
			kFilters.platform = GMRPlatformBattleNet;
			break;
			
		case 1: // Playstation 2
			kFilters.platform = GMRPlatformPlaystation2;
			break;
			
		case 2: // Playstation 3
			kFilters.platform = GMRPlatformPlaystation3;
			break;
			
		case 3: // Steam
			kFilters.platform = GMRPlatformSteam;
			break;
			
		case 4: // Wii
			kFilters.platform = GMRPlatformWii;
			break;
			
		case 5: // XBox 360
			kFilters.platform = GMRPlatformXBox360;
			break;
			
	}
	
	[self selectPlatform:kFilters.platform];
	
}


- (void)dealloc {
    [super dealloc];
}


@end
