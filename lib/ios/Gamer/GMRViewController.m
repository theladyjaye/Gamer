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
- (void)changeViews:(UIViewController *)controller;
{
	
	[self.navigationController pushViewController:controller animated:YES];
	
}

- (void)popViewController
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
