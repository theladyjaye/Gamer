//
//  GMRGameLobbyController+TableView.m
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRGameLobbyController+TableView.h"
#import "GMRGlobals.h"
#import "GMRClient.h"
#import "GMRFilter.h"
#import "GMRGame.h"
#import "GMRMatch.h"
#import "NSDate+JSON.h"
#import "GMRMatchListCell.h"
#import "GMRGameDetailController.h"
#import "GMRGameDetailController+PlayerList.h"


@implementation GMRGameLobbyController(TableView)

- (void)resultsTableRefresh:(GMRFilter *)filter
{
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	if(filter.game.id)
	{
		[kGamerApi matchesScheduledForPlatform:filter.platform 
									   andGame:filter.game.id 
							   andTimeInterval:filter.timeInterval 
								  withCallback:^(BOOL ok, NSDictionary * response){
									  
									  if(ok)
									  {
										  [self processFilterResultsOnBackgroundThread:response];
									  }
									  else 
									  {
										  [self noFilterResultsOnBackgroundThread];
									  }

								  }];
	}
	else 
	{
		[kGamerApi matchesScheduledForPlatform:filter.platform  
							   andTimeInterval:filter.timeInterval 
								  withCallback:^(BOOL ok, NSDictionary * response){
									  
									  if(ok)
									  {
										  [self processFilterResultsOnBackgroundThread:response];
									  }
									  else 
									  {
										  [self noFilterResultsOnBackgroundThread];
									  }
								  }];
	}
}

- (void)processFilterResultsOnBackgroundThread:(NSDictionary *)response
{
	NSArray * tempMatches = [response objectForKey:@"matches"];
	NSLog(@"Total Matches: %i", [tempMatches count]);
	
	if ([tempMatches count] > 0)
	{
		if(matches)
		{
			[matches release];
			matches = nil;
		}
		
		matches = [NSMutableArray array];//:(NSArray *)[response objectForKey:@"matches"]];
		[matches retain];
		
		NSLog(@"Converting to Model Objects");
		
		for(NSDictionary * item in tempMatches)
		{
			
			GMRMatch * currentMatch = [GMRMatch matchWithDicitonary:item];
			[matches addObject:currentMatch];
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			
			if(noneView)
			{
				[noneView removeFromSuperview];
				noneView = nil;
				[self beginCellUpdates];
			}
			
			[matchesTable reloadData];
			[self beginCellUpdates];
		});
	}
	else 
	{
		[matches release];
		matches = nil;
		[self noFilterResultsOnBackgroundThread];
	}
}

- (void)noFilterResultsOnBackgroundThread
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[self noMatchesScheduled];
	});
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
    if (cell == nil) 
	{
		// nib is there for coordinate reference only.
		cell = [[[GMRMatchListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	GMRMatch * item = [matches objectAtIndex:indexPath.row];
	
	cell.labelString   = item.label;
	cell.gameString    = item.game.label;
	cell.platform      = item.platform;
	//cell.dateString    = [NSDate relativeTime:item.scheduled_time];
	cell.scheduled_time = item.scheduled_time;
	[cell setNeedsDisplay];
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	GMRGameDetailController * detail = [[GMRGameDetailController alloc] initWithMatch:[matches objectAtIndex:indexPath.row]];
	detail.matchesDataSourceController = self;
	[self.navigationController pushViewController:detail animated:YES];
	[detail release];
}

@end
