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
#import "GMRGameListCell.h"

@implementation GMRChooseGameAndMode(SearchTableView)

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
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
							 else 
							 {
								 games = nil;
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
	static NSString *CellIdentifier     = @"GameListCell";
	
	GMRGameListCell *cell = (GMRGameListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
		cell = [[[GMRGameListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.title = [[games objectAtIndex:indexPath.row] objectForKey:@"label"];
	
	return cell;
}

- (void)searchResultsTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	GMRGame * selectedGame = [GMRGame gameWithDicitonary:[games objectAtIndex:indexPath.row]];
	self.gameLabel.text = selectedGame.label;
	
	kCreateMatchProgress.game    = selectedGame;
	
	[self.searchDisplayController setActive:NO animated:YES];
}

@end
