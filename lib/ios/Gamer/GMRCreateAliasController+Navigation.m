//
//  GMRCreateAliasController+Navigation.m
//  Gamer
//
//  Created by Adam Venturella on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRCreateAliasController+Navigation.h"


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
	/*GMRChoosePlatformController * controller = [[GMRChoosePlatformController alloc] initWithNibName:nil 
																							 bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];*/
}

- (void)selectAlias
{
	
}

@end
