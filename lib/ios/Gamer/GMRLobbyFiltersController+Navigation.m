//
//  GMRLobbyFiltersController+Navigation.m
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRLobbyFiltersController+Navigation.h"
#import "GMRLobbyFiltersChoosePlatform.h"
#import "GMRGameLobbyGlobals.h"
#import "GMRFilter.h"
#import "GMRChooseGame.h"
#import "GMRAlertView.h"

@implementation GMRLobbyFiltersController(Navigation)

- (IBAction)selectOption:(id)sender
{
	NSInteger tag = [sender tag];
	
	switch(tag)
	{
		case 0: // Platform
			[self selectPlatform];
			break;
			
		case 1: // Game
			[self selectGame];
			break;			
	}
}


- (void)selectPlatform
{
	GMRLobbyFiltersChoosePlatform * controller = [[GMRLobbyFiltersChoosePlatform alloc] initWithNibName:@"GMRChoosePlatformController" 
																				   bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)selectGame
{
	if(kFilters.platform != GMRPlatformUnknown)
	{
		GMRChooseGame * controller = [[GMRChooseGame alloc] initWithNibName:nil 
																				   bundle:nil];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
	else 
	{
		GMRAlertView * alert = [[GMRAlertView alloc]  initWithStyle:GMRAlertViewStyleNotification 
															  title:@"Choose Your Platform" 
															message:@"Please choose a platform prior to chooseing a game" 
														   callback:^(GMRAlertView * target){
															   [target release];
														   }];
		
		[alert show];
	}
	
}
@end
