    //
//  GMRAliasChoosePlatform.m
//  Gamer
//
//  Created by Adam Venturella on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRAliasChoosePlatform.h"
#import "GMRCreateAliasGlobals.h"
#import "GMRAlias.h"
#import "GMRLabel.h"

@implementation GMRAliasChoosePlatform

- (void)configure
{
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Platform"];
	
	if(kCreateAliasProgress.platform != GMRPlatformUnknown)
	{
		
		// when you come back we need to select your last selected button
		// so we need the button IBOutlets so we have something to target
		[self selectPlatform:kCreateAliasProgress.platform];
	}
}

- (IBAction)selectPlatformAction:(id)sender
{
	NSUInteger tag = [sender tag];
	
	switch(tag)
	{
		case 0: // Battle.Net
			kCreateAliasProgress.platform = GMRPlatformBattleNet;
			break;
		
		case 1: // Playstation 2
			kCreateAliasProgress.platform = GMRPlatformPlaystation2;
			break;
			
		case 2: // Playstation 3
			kCreateAliasProgress.platform = GMRPlatformPlaystation3;
			break;
			
		case 3: // Steam
			kCreateAliasProgress.platform = GMRPlatformSteam;
			break;
			
		case 4: // Wii
			kCreateAliasProgress.platform = GMRPlatformWii;
			break;
			
		case 5: // XBox 360
			kCreateAliasProgress.platform = GMRPlatformXBox360;
			break;
			
	}
	
	[self selectPlatform:kCreateAliasProgress.platform];
	
}


- (void)dealloc {
    [super dealloc];
}


@end
