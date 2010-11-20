//
//  GMRViewController.m
//  Gamer
//
//  Created by Adam Venturella on 11/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRViewController.h"
#import "GMRGlobals.h"

@implementation GMRViewController
- (void)changeViews:(UIViewController *)controller withTitle:(NSString *)title;
{
	UINavigationItem * navItem   = [[UINavigationItem alloc] initWithTitle:title];
	UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
												  				    style:UIBarButtonItemStylePlain
																   target:self 
																   action:@selector(popViewController)];
	navItem.backBarButtonItem  = backButton;
	
	
	[self.navigationController pushViewController:controller animated:YES];
	
	[navItem release];
	[backButton release];
}

- (void)popViewController
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
