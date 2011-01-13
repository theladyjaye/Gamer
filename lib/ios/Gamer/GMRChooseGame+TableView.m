//
//  GMRChooseGame+TableView.m
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRChooseGame+TableView.h"
#import "GMRChooseGame+SearchTableView.h"

@implementation GMRChooseGame(TableView)
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	if(tableView == self.searchDisplayController.searchResultsTableView)
		return [self numberOfSectionsInSearchResultsTableView:tableView];
	
	// Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	if(tableView == self.searchDisplayController.searchResultsTableView)
		return [self searchResultsTableView:tableView numberOfRowsInSection:section];
	
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
		return [self searchResultsTableView:tableView cellForRowAtIndexPath:indexPath];
	
	return nil;
}






#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if(tableView == self.searchDisplayController.searchResultsTableView)
	{
		[self searchResultsTableView:tableView didSelectRowAtIndexPath:indexPath];
		return;
	}
}
@end
