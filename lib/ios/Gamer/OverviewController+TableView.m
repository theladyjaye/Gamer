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
#import "OverviewController.h"

@implementation OverviewController(TableView)

- (void)matchesTableRefresh
{
	//[matches release];
	//matches = nil;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[kGamerApi matchesScheduled:^(BOOL ok, NSDictionary * response)
	 {
		 if(ok)
		 {
			 // NSLog(@"%@", response);
			 /*if(matches)
			 {
				 [matches release];
				 matches = nil;
			 }*/
			 
			 
			 NSArray * tempMatches = [response objectForKey:@"matches"];
			 NSLog(@"Total Matches: %i", [tempMatches count]);
			 if ([tempMatches count] > 0)
			 {
				 //matches = [NSMutableArray array];//:(NSArray *)[response objectForKey:@"matches"]];
				 
				 NSLog(@"Converting to Model Objects");
				 
				 for(NSDictionary * item in tempMatches)
				 {
					 GMRMatch * currentMatch = [GMRMatch matchWithDicitonary:item];
					 [kScheduledMatches addObject:currentMatch];
					 //[matches addObject:currentMatch];
				 }
				
				 
				//[matches retain];
				dispatch_async(dispatch_get_main_queue(), ^{
					
					[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
					[matchesTable reloadData];
				});
			 }
			 else 
			 {
				 //matches = nil;
				 dispatch_async(dispatch_get_main_queue(), ^{
					 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
					 [self noMatchesScheduled];
				 });
			 }

		 }
		 else 
		 {
			 NSLog(@"%@", response);
			 dispatch_async(dispatch_get_main_queue(), ^{
				 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
				 [self noMatchesScheduled];
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
    return [kScheduledMatches count];//matches ? [matches count] : 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MatchListCell";
    
	GMRMatchListCell *cell = (GMRMatchListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
		// nib is there for coordinate reference only.
		cell = [[[GMRMatchListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	GMRMatch * item = [kScheduledMatches objectAtIndex:indexPath.row];
	 
	cell.labelString   = item.label;
	cell.gameString    = item.game.label;
	cell.platform      = item.platform;
	//cell.dateString    = [NSDate relativeTime:item.scheduled_time];
	cell.scheduled_time = item.scheduled_time;
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	GMRGameDetailController * detail = [[GMRGameDetailController alloc] initWithMatch:[kScheduledMatches objectAtIndex:indexPath.row] 
																		   membership:GMRMatchMembershipMember];
	detail.matchesDataSourceController = self;
	[self.navigationController pushViewController:detail animated:YES];
	[detail release];
}
@end
