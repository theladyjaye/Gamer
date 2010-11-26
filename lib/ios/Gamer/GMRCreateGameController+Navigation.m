//
//  GMRCreateGameController+Navigation.m
//  Gamer
//
//  Created by Adam Venturella on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRCreateGameController+Navigation.h"
#import "GMRChoosePlatformController.h"
#import "GMRChooseGameAndMode.h"
#import "GMRChooseDateTime.h"
#import "GMRChooseAvailability.h"
#import "GMRChoosePlayers.h"
#import "GMRChooseDescription.h"
#import "GMRAlertView.h"

#import "GMRCreateGameGlobals.h"
#import "GMRMatch.h"
#import "GMRGame.h"

@implementation GMRCreateGameController(Navigation)

- (IBAction)selectPlatform
{
	GMRChoosePlatformController * controller = [[GMRChoosePlatformController alloc] initWithNibName:nil 
																							 bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (IBAction)selectGameAndMode
{
	if(kCreateMatchProgress.platform != GMRPlatformUnknown)
	{
		GMRChooseGameAndMode * controller = [[GMRChooseGameAndMode alloc] initWithNibName:nil 
																				   bundle:nil];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
	else 
	{
		GMRAlertView * alert = [[GMRAlertView alloc]  initWithStyle:GMRAlertViewStyleNotification 
															  title:@"Choose Your Platform" 
															message:@"Please choose a platform prior to chooseing a game/mode" 
														   callback:^(GMRAlertView * target){
															   [target release];
														   }];
		
		[alert show];
	}
	
}

- (IBAction)selectAvailability
{	
	GMRChooseAvailability * controller = [[GMRChooseAvailability alloc] initWithNibName:nil 
																			     bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (IBAction)selectPlayers
{
	if(kCreateMatchProgress.game)
	{
		GMRChoosePlayers * controller = [[GMRChoosePlayers alloc] initWithNibName:nil 
																		   bundle:nil];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
	else 
	{
		GMRAlertView * alert = [[GMRAlertView alloc]  initWithStyle:GMRAlertViewStyleNotification 
															  title:@"Choose Your Game" 
															message:@"Please choose a game prior to selecting the number of players" 
														   callback:^(GMRAlertView * target){
															   [target release];
														   }];
		
		[alert show];
	}
	
}

- (IBAction)selectTime
{	
	GMRChooseDateTime * controller = [[GMRChooseDateTime alloc] initWithNibName:nil 
																	     bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (IBAction)selectDescription
{
	GMRChooseDescription * controller = [[GMRChooseDescription alloc] initWithNibName:nil 
																	           bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}
@end
