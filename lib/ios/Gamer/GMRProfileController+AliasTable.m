//
//  GMRProfileController+AliasTable.m
//  Gamer
//
//  Created by Adam Venturella on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRProfileController+AliasTable.h"
#import "GMRAliasListCell.h"
#import "GMRGlobals.h"
#import "GMRAlias.h"
#import "GMRTypes.h"

@implementation GMRProfileController(AliasTable)
- (void)aliasTableRefresh
{
	if(aliases)
	{
		[aliases release];
		aliases = nil;
	}
	
	//[self.aliasTableView reloadData];
	
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	/*
	[kGamerApi matchesScheduled:^(BOOL ok, NSDictionary * response)
	 {
		 if(ok)
		 {
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
	 */
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;//aliases ? [aliases count] : 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"AliasListCell";
    
	GMRAliasListCell *cell = (GMRAliasListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
		// nib is there for coordinate reference only.
		cell = [[[GMRAliasListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	//GMRAlias * item = [aliases objectAtIndex:indexPath.row];
	
	cell.alias    = @"logix812";//item.alias;
	cell.platform = GMRPlatformPlaystation3;//item.platform;	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	/*GMRGameDetailController * detail = [[GMRGameDetailController alloc] initWithMatch:[kScheduledMatches objectAtIndex:indexPath.row]];
	detail.matchesDataSourceController = self;
	[self.navigationController pushViewController:detail animated:YES];
	[detail release];
	 */
}
@end
