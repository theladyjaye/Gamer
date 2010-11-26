//
//  GMRChooseGameAndMode+TableView.m
//  Gamer
//
//  Created by Adam Venturella on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRChooseGameAndMode+TableView.h"
#import "GMRChooseGameAndMode+SearchTableView.h"
#import "GMRMatch.h"
#import "GMRGame.h"
#import "GMRCreateGameGlobals.h"

@implementation GMRChooseGameAndMode(TableView)

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
	
	// Return the number of rows in the section.
    return [kCreateMatchProgress.game.modes count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
		return [self searchResultsTableView:tableView cellForRowAtIndexPath:indexPath];
		
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.textLabel.text = [kCreateMatchProgress.game.modes objectAtIndex:indexPath.row];
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if(tableView == self.searchDisplayController.searchResultsTableView)
	{
		[self searchResultsTableView:tableView didSelectRowAtIndexPath:indexPath];
		return;
	}
	
	NSString * mode = [kCreateMatchProgress.game.modes objectAtIndex:indexPath.row];
	modeLabel.text  = mode;
	kCreateMatchProgress.game.selectedMode = indexPath.row;		
}




@end

