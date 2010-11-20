//
//  GMRPlayersForMatch.m
//  Gamer
//
//  Created by Adam Venturella on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRPlayersForMatch.h"

#include <dispatch/dispatch.h>
#import "GMRGlobals.h"
#import "GMRClient.h"
#import "NSDate+JSON.h"
#import "GMRPlayerListCell.h"

enum {
	PlayerListCellStylePlayer,
	PlayerListCellStyleOpen
};
typedef NSUInteger PlayerListCellStyle;

@implementation GMRPlayersForMatch
@synthesize maxPlayers;

- (void)refresh:(UIView *)target;
{
	UITableView * tableView = (UITableView *)target;
	
	[kGamerApi matchesScheduled:^(BOOL ok, NSDictionary * response)
	 {
		 if(ok)
		 {
			 NSLog(@"%@", response);
			 //players = (NSArray *)[response objectForKey:@"matches"];
			 //[players retain];
			 dispatch_async(dispatch_get_main_queue(), ^{
				 [tableView reloadData];
			 });
		 }
	 }];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.maxPlayers;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PlayerListCell";
	PlayerListCellStyle cellStyle;
    
	GMRPlayerListCell *cell = (GMRPlayerListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
		if(indexPath.row > ([players count] -1 ))
			cellStyle = PlayerListCellStyleOpen;
		else 
			cellStyle = PlayerListCellStylePlayer;
		
		//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"GMRPlayerListCell" owner:self options:nil];
        cell = [nib objectAtIndex:cellStyle];
    }
    
	if(cellStyle == PlayerListCellStylePlayer)
	{
		cell.player.text = @"Player!!";
		/*
		 NSDictionary * item = [matches objectAtIndex:indexPath.row];
		 NSDictionary * game = [item objectForKey:@"game"];
		 
		 NSString * scheduled_time = [item objectForKey:@"scheduled_time"];
		 NSDate * date = [NSDate dateWithJSONString:scheduled_time];
		 
		 NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		 [formatter setTimeZone:[NSTimeZone localTimeZone]];
		 
		 // TODO: nned to let the user configure how they want their time.
		 [formatter setDateFormat:@"EEE, LLL dd hh:mm a"];
		 NSString * displayDate = [formatter stringFromDate:date];
		 [formatter release];
		 
		 cell.label.text   = (NSString *)[item objectForKey:@"label"];
		 cell.date.text    = displayDate;
		 cell.game.text    = [game objectForKey:@"label"];
		 cell.players.text = [[item objectForKey:@"maxPlayers"] stringValue];
		 cell.mode.text    = [item objectForKey:@"mode"];
		 */
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

- (void)dealloc
{
	[players release];
}



@end