//
//  GMRGameDetailController+PlayerList.m
//  Gamer
//
//  Created by Adam Venturella on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#include <dispatch/dispatch.h>
#import "GMRGameDetailController+PlayerList.h"

#import "GMRGlobals.h"
#import "GMRClient.h"
#import "NSDate+JSON.h"
#import "GMRPlayerListCell.h"


enum {
	PlayerListCellStylePlayer,
	PlayerListCellStyleOpen
};
typedef NSUInteger PlayerListCellStyle;


@implementation GMRGameDetailController(PlayerList)

- (void)playersTableRefresh
{
	/*
	 {
		"_id" = e68ce2a591a7500a3551255d2c003d61;
		"_rev" = "1-97419aefed46cc225edce4bf5a79c01a";
		availability = public;
		"created_by" = aventurella;
		"created_on" = "2010-11-19T15:12:17.447Z";
		game =             {
							id = "game/mario-kart";
							label = "Mario Kart";
							platform = wii;
						   };
		label = "Little Kartage down home style";
		maxPlayers = 4;
		mode = Deathmatch;
		"scheduled_time" = "2010-11-19T21:12:17.000Z";
		type = match;
	 }
	 */
	
	NSDictionary * gameData = [match objectForKey:@"game"];
	GMRPlatform platform    = [kGamerApi platformForString:[gameData objectForKey:@"platform"]];
	NSString * game = [[[gameData objectForKey:@"id"] componentsSeparatedByString:@"/"] objectAtIndex:1];
	
	
	if(platform != GMRPlatformUnknown)
	{
		[kGamerApi playersForMatch:platform gameId:game matchId:[match objectForKey:@"_id"] callback:^(BOOL ok, NSDictionary * response)
		 {
			 /* response :
			  ok = 1;
			  players = (
				{
					alias = logix812;
					username = aventurella;
				}
			  );
			  */
			 
			 if(ok)
			 {
				 self.playersForMatch = (NSArray *)[response objectForKey:@"players"];
				 dispatch_async(dispatch_get_main_queue(), ^{
					 [playersTableView reloadData];
				 });
			 }
		 }];
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.playersForMatch == nil ? 0 : [[match objectForKey:@"maxPlayers"] intValue];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier     = @"PlayerListCell";
	static NSString *CellIdentifierOpen = @"PlayerListCellOpen";
	
	PlayerListCellStyle cellStyle = indexPath.row > ([self.playersForMatch count] -1 ) ? PlayerListCellStyleOpen : PlayerListCellStylePlayer;
	
	NSString * reusableId = cellStyle == PlayerListCellStyleOpen ? CellIdentifierOpen : CellIdentifier;
    
	GMRPlayerListCell *cell = (GMRPlayerListCell *)[tableView dequeueReusableCellWithIdentifier:reusableId];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) 
	{
		//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"GMRPlayerListCell" owner:self options:nil];
        cell = [nib objectAtIndex:cellStyle];
    }
    
	if(cellStyle == PlayerListCellStylePlayer)
	{
		cell.player.text = [[self.playersForMatch objectAtIndex:indexPath.row] objectForKey:@"alias"];
	}
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"This row!");
	// Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}
@end
