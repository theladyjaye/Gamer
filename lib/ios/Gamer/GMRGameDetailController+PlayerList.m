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
#import "GMRMatch.h"
#import "GMRGame.h"


enum {
	PlayerListCellStylePlayer,
	PlayerListCellStyleOpen
};
typedef NSUInteger PlayerListCellStyle;


@implementation GMRGameDetailController(PlayerList)

- (void)playersTableRefresh
{	
	GMRPlatform platform    = match.game.platform;
	NSString * game = [[match.game.id componentsSeparatedByString:@"/"] objectAtIndex:1];
	
	
	if(platform != GMRPlatformUnknown)
	{
		[kGamerApi playersForMatch:platform gameId:game 
						   matchId:match.id 
						  callback:^(BOOL ok, NSDictionary * response)
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
    return self.playersForMatch == nil ? 0 : match.maxPlayers;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier         = @"PlayerListCell";
	static NSString *CellIdentifierCreator  = @"PlayerListCellCreator";
	static NSString *CellIdentifierOpen     = @"PlayerListCellOpen";
	
	PlayerListCellStyle cellStyle = indexPath.row > ([self.playersForMatch count] -1 ) ? PlayerListCellStyleOpen : PlayerListCellStylePlayer;
	
	NSString * reusableId;
	NSString * alias = @"-- Open --";
	NSString * username;
	
	if(cellStyle == PlayerListCellStylePlayer)
	{
		
		alias      = [[self.playersForMatch objectAtIndex:indexPath.row] objectForKey:@"alias"];
		username   = [[self.playersForMatch objectAtIndex:indexPath.row] objectForKey:@"username"];		
		reusableId = [username isEqualToString:match.created_by]? CellIdentifierCreator : CellIdentifier;
	}
	else 
	{
		reusableId = cellStyle == PlayerListCellStyleOpen ? CellIdentifierOpen : CellIdentifier;
	}

	
	GMRPlayerListCell *cell = (GMRPlayerListCell *)[tableView dequeueReusableCellWithIdentifier:reusableId];
    
	if (cell == nil) 
	{
		cell = [[[GMRPlayerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableId] autorelease];
    }
    
	if(cellStyle == PlayerListCellStylePlayer)
	{
		cell.player = alias;
	}
	else 
	{
		cell.player = alias;
	}

	
	//cell.player = [[self.playersForMatch objectAtIndex:indexPath.row] objectForKey:@"alias"];
	//NSLog(@"%@", cell.player);
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
