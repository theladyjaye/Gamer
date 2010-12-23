//
//  GMRGameLobbyController+TableView.m
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRGameLobbyController+TableView.h"
#import "GMRGameLobbyGlobals.h"
#import "GMRGlobals.h"
#import "GMRClient.h"
#import "GMRFilter.h"
#import "GMRGame.h"

@implementation GMRGameLobbyController(TableView)

- (void)resultsTableRefresh
{
	if(kFilters.game.id)
	{
		[kGamerApi matchesScheduledForPlatform:kFilters.platform 
									   andGame:kFilters.game.id 
							   andTimeInterval:kFilters.timeInterval 
								  withCallback:^(BOOL ok, NSDictionary * response){
								  }];
	}
	else 
	{
		[kGamerApi matchesScheduledForPlatform:kFilters.platform  
							   andTimeInterval:kFilters.timeInterval 
								  withCallback:^(BOOL ok, NSDictionary * response){
								  }];
	}
}
@end
