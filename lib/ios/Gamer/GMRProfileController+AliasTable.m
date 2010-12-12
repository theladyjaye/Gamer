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
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[kGamerApi aliases:^(BOOL ok, NSDictionary * response)
	 {
		 if(ok)
		 {
			 NSArray * tempCollection = [response objectForKey:@"aliases"];
			 
			 if ([tempCollection count] > 0)
			 {
				 aliases = [[NSMutableArray array] retain];
				 
				 for(NSDictionary * item in tempCollection)
				 {
					 GMRAlias * currentAlias = [GMRAlias aliasWithDicitonary:item];
					 [aliases addObject:currentAlias];
				 }
				 
				 dispatch_async(dispatch_get_main_queue(), ^{
					 
					 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
					 [aliasTableView reloadData];
				 });
			 }
			 else 
			 {
				 dispatch_async(dispatch_get_main_queue(), ^{
					 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
					 [self noAliases];
				 });
			 }
			 
		 }
		 else 
		 {
			 dispatch_async(dispatch_get_main_queue(), ^{
				 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
				 [self noAliases];
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
    return aliases ? [aliases count] : 0;
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
	
	GMRAlias * item = [aliases objectAtIndex:indexPath.row];
	
	cell.alias    = item.alias;
	cell.platform = item.platform;	
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
