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
#import "GMRMatch.h"
#import "GMRGame.h"
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
			 // NSLog(@"%@", response);
			 if(matches)
			 {
				 [matches release];
				 matches = nil;
			 }
			 
			 
			 NSArray * tempMatches = [response objectForKey:@"matches"];
			 NSLog(@"Total Matches: %i", [tempMatches count]);
			 if ([tempMatches count] > 0)
			 {
				 matches = [NSMutableArray array];//:(NSArray *)[response objectForKey:@"matches"]];
				 
				 NSLog(@"Converting to Model Objects");
				 
				 for(NSDictionary * item in tempMatches)
				 {
					 GMRMatch * currentMatch = [GMRMatch matchWithDicitonary:item];
					 [matches addObject:currentMatch];
				 }
				
				 
				[matches retain];
				dispatch_async(dispatch_get_main_queue(), ^{[matchesTable reloadData];});
			 }
			 else 
			 {
				 matches = nil;
				 dispatch_async(dispatch_get_main_queue(), ^{[self noMatchesScheduled];});
			 }

		 }
		 else 
		 {
			 NSLog(@"%@", response);
			 dispatch_async(dispatch_get_main_queue(), ^{[self noMatchesScheduled];});
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
        cell = (GMRMatchListCell *)[nib objectAtIndex:0];
        //self.tvCell = nil;
    }
    
	 GMRMatch * item = [matches objectAtIndex:indexPath.row];
	 //NSDictionary * item = [matches objectAtIndex:indexPath.row];
	 //NSDictionary * game = [item objectForKey:@"game"];
	 
	 //NSDate * scheduled_time = [NSDate dateWithJSONString:[item objectForKey:@"scheduled_time"]];
	 /*NSDate * date = [NSDate dateWithJSONString:scheduled_time];
	 
	 NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	 [formatter setTimeZone:[NSTimeZone localTimeZone]];
	 
	 // TODO: nned to let the user configure how they want their time.
	 [formatter setDateFormat:@"EEE, LLL dd hh:mm a"];
	 NSString * displayDate = [formatter stringFromDate:date];
	 [formatter release];
	  */
	 
	//NSLog(@"%@", [[item objectForKey:@"maxPlayers"] class]);
	cell.label.text   = item.label;
	cell.date.text    = [NSDate gamerScheduleTimeString:item.scheduled_time];
	cell.game.text    = item.game.label;
	cell.platform     = item.game.platform;
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	GMRGameDetailController * detail = [[GMRGameDetailController alloc] initWithMatch:[matches objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:detail animated:YES];
	[detail release];
}
@end
