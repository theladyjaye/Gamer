//
//  GMRCreateAliasController+Navigation.m
//  Gamer
//
//  Created by Adam Venturella on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRCreateAliasController+Navigation.h"
#import "GMRAliasChoosePlatform.h"
#import "GMRChooseAlias.h"

@implementation GMRCreateAliasController(Navigation)

- (IBAction)selectOption:(id)sender
{
	NSInteger tag = [sender tag];
	
	switch(tag)
	{
		case 0: // Platform
			[self selectPlatform];
			break;
			
		case 1: // Alias
			[self selectAlias];
			break;			
	}
}


- (void)selectPlatform
{
	GMRAliasChoosePlatform * controller = [[GMRAliasChoosePlatform alloc] initWithNibName:@"GMRChoosePlatformController" 
																				   bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)selectAlias
{
	GMRChooseAlias * controller = [[GMRChooseAlias alloc] initWithNibName:nil 
																   bundle:nil];
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	
}

@end
