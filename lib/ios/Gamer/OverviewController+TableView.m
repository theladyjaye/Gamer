//
//  OverviewController+TableView.m
//  Gamer
//
//  Created by Adam Venturella on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#include <dispatch/dispatch.h>
#import "OverviewController+TableView.h"
#import "GMRGlobals.h"
#import "GMRClient.h"
#import "NSDate+JSON.h"
#import "GMRMatchListCell.h"
#import "GMRGameDetailController.h"
#import "GMRGameDetailController+PlayerList.h"

@implementation OverviewController(TableView)

- (void)matchesTableRefresh
{
	[matches release];
	matches = nil;
	
	[kGamerApi matchesScheduled:^(BOOL ok, NSDictionary * response)
	 {
		 if(ok)
		 {
			 NSLog(@"%@", response);
			 matches = (NSArray *)[response objectForKey:@"matches"];
			 [matches retain];
			 dispatch_async(dispatch_get_main_queue(), ^{[matchesTable reloadData];});
		 }
		 else {
			 NSLog(@"%@", response);
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
    return matches ? [matches count] : 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MatchListCell";
    
	GMRMatchListCell *cell = (GMRMatchListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"GMRMatchListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        //self.tvCell = nil;
    }
    
	 NSDictionary * item = [matches objectAtIndex:indexPath.row];
	 NSDictionary * game = [item objectForKey:@"game"];
	 
	 NSString * scheduled_time = [item objectForKey:@"scheduled_time"];
	 /*NSDate * date = [NSDate dateWithJSONString:scheduled_time];
	 
	 NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	 [formatter setTimeZone:[NSTimeZone localTimeZone]];
	 
	 // TODO: nned to let the user configure how they want their time.
	 [formatter setDateFormat:@"EEE, LLL dd hh:mm a"];
	 NSString * displayDate = [formatter stringFromDate:date];
	 [formatter release];
	  */
	 
	 cell.label.text   = (NSString *)[item objectForKey:@"label"];
	 cell.date.text    = [NSDate gamerScheduleTimeString:scheduled_time];
	 cell.game.text    = [game objectForKey:@"label"];
	 cell.players.text = [[item objectForKey:@"maxPlayers"] stringValue];
	 cell.mode.text    = [item objectForKey:@"mode"];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	GMRGameDetailController * detail = [[GMRGameDetailController alloc] initWithDictionary:[matches objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:detail animated:YES];
	//[self changeViews:detail withTitle:@"GameDetail"];
	[detail release];
	
	
}
@end
