//
//  GMRChooseGame+SearchTableView.m
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#include <dispatch/dispatch.h>
#import "GMRChooseGame+SearchTableView.h"
#import "GMRGameLobbyGlobals.h"
#import "GMRGlobals.h"
#import "GMRClient.h"
#import "GMRGameListCell.h"
#import "GMRGame.h"
#import "GMRFilter.h"

@implementation GMRChooseGame(SearchTableView)
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
	[games release];
	games = nil;
	[controller.searchResultsTableView reloadData];
	
	[UIView animateWithDuration:0.25 
					 animations:^{
						 navigationBarShadow.transform = CGAffineTransformMakeTranslation(0.0, -64.0);
					 }];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	[UIView animateWithDuration:0.25 
					 animations:^{
						 navigationBarShadow.transform = CGAffineTransformIdentity;
					 }];
	
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
	controller.searchResultsTableView.backgroundColor = self.view.backgroundColor;
	controller.searchResultsTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
	controller.searchResultsTableView.rowHeight       = 37.0;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
	//CGSize size = controller.searchContentsController.view.frame.size;
	//CGPoint point = controller.searchContentsController.view.frame.origin;
	
	//controller.searchContentsController.view.frame = CGRectMake(point.x, point.y, size.width, size.height + 60);
	//controller.searchResultsTableView.transform = CGAffineTransformMakeTranslation(0.0, 2.0);
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	if([searchString length] > 2)
	{
		[kGamerApi searchPlatform:kFilters.platform 
						  forGame:searchString
					 withCallback:^(BOOL ok, NSDictionary* response){
						 if(ok)
						 { 
							 if([[response objectForKey:@"games"] count] > 0)
							 {
								 //NSLog(@"%@", response);
								 
								 dispatch_async(dispatch_get_main_queue(), ^{ 
									 
									 if(games)
									 {
										 [games release];
										 games = nil;
									 }
									 
									 games = [response objectForKey:@"games"];
									 [games retain];
									 
									 [controller.searchResultsTableView reloadData]; 
								 
								 });
							 }
							 else 
							 {
								dispatch_async(dispatch_get_main_queue(), ^{ 
									if(games)
									{
										[games release];
										games = nil;
										[controller.searchResultsTableView reloadData];
									}
								});
							 }
							 
						 }
					 }];
		
		return YES;
	}
	
	
	if(games)
	{
		[games release];
		games = nil;
	
		[controller.searchResultsTableView reloadData]; 
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
	static NSString *CellIdentifier     = @"GameListCell";
	
	GMRGameListCell *cell = (GMRGameListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
		cell = [[[GMRGameListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.title = [[games objectAtIndex:indexPath.row] objectForKey:@"label"];
	[cell setNeedsDisplay];
	
	return cell;
}

- (void)searchResultsTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	GMRGame * selectedGame = [GMRGame gameWithDicitonary:[games objectAtIndex:indexPath.row]];
	self.gameLabel.text = selectedGame.label;
	kFilters.game = selectedGame;
	
	
	[self.searchDisplayController setActive:NO animated:YES];
}
@end
