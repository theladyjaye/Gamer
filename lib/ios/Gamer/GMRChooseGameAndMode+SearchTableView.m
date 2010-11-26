//
//  GMRChooseGameAndMode+SearchTableView.m
//  Gamer
//
//  Created by Adam Venturella on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#include <dispatch/dispatch.h>

#import "GMRChooseGameAndMode+SearchTableView.h"
#import "GMRPlayerListCell.h"
#import "GMRGlobals.h"
#import "GMRClient.h"
#import "GMRCreateGameGlobals.h"
#import "GMRTypes.h"
#import "GMRMatch.h"
#import "GMRGame.h"

@implementation GMRChooseGameAndMode(SearchTableView)

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
	controller.searchResultsTableView.backgroundColor = self.view.backgroundColor;
	controller.searchResultsTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
	controller.searchResultsTableView.rowHeight       = 33.0;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
	//CGSize size = controller.searchContentsController.view.frame.size;
	//CGPoint point = controller.searchContentsController.view.frame.origin;
	
	//controller.searchContentsController.view.frame = CGRectMake(point.x, point.y, size.width, size.height + 60);
	controller.searchResultsTableView.transform = CGAffineTransformMakeTranslation(0.0, 2.0);
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	if([searchString length] > 2)
	{
		[kGamerApi searchPlatform:kCreateMatchProgress.platform 
						  forGame:searchString
					 withCallback:^(BOOL ok, NSDictionary* response){
						 if(ok)
						 {
							 games = [response objectForKey:@"games"];
							 if([games count] > 0)
							 {
								 NSLog(@"%@", response);
								 [games retain];
								 dispatch_async(dispatch_get_main_queue(), ^{ [controller.searchResultsTableView reloadData]; });
							 }
						 }
					 }];
	}

	return NO;
}


- (NSInteger)numberOfSectionsInSearchResultsTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)searchResultsTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return games ? [games count] : 0;
}


- (UITableViewCell *)searchResultsTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier     = @"PlayerListCell";
	
	GMRPlayerListCell *cell = (GMRPlayerListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
		//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"GMRPlayerListCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
		
		cell.player.transform     = CGAffineTransformMakeTranslation((10.0 - cell.player.frame.origin.x), 0.0);
		cell.player.textAlignment = UITextAlignmentLeft;
	}
	
	cell.player.text          = [[games objectAtIndex:indexPath.row] objectForKey:@"label"];
	
	return cell;
}

- (void)searchResultsTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	GMRGame * selectedGame = [[GMRGame alloc] init];
	selectedGame.id = [[games objectAtIndex:indexPath.row] objectForKey:@"id"];
	selectedGame.label = [[games objectAtIndex:indexPath.row] objectForKey:@"label"];
	selectedGame.maxPlayers = [[[games objectAtIndex:indexPath.row] objectForKey:@"maxPlayers"] intValue];
	selectedGame.modes = [[games objectAtIndex:indexPath.row] objectForKey:@"modes"];
	
	self.gameLabel.text = selectedGame.label;
	
	kCreateMatchProgress.game    = selectedGame;
	
	[selectedGame release];
	
	[self.searchDisplayController setActive:NO animated:YES];
}

@end
