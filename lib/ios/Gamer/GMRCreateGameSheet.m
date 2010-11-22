//
//  GMRCreateGameSheet.m
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRCreateGameSheet.h"


@implementation GMRCreateGameSheet

- (void)viewDidLoad
{
	UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithTitle:@"Back"
																style:UIBarButtonItemStylePlain 
															   target:self 
															   action:@selector(cancelSheet)];
	
	/*UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithTitle:@"Save" 
																style:UIBarButtonItemStylePlain
															   target:self 
															   action:@selector(cancelSheet)];
	*/
	
	self.navigationItem.leftBarButtonItem = cancel;
	[cancel release];
	
	 //self.navigationItem.rightBarButtonItem = done;*/
	 //[done release];
	
	[super viewDidLoad];
}

- (void)cancelSheet
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
