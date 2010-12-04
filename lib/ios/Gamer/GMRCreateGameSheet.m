//
//  GMRCreateGameSheet.m
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRCreateGameSheet.h"
#import "UIButton+GMRButtonTypes.h"

@implementation GMRCreateGameSheet

- (void)viewDidLoad
{
	
	[self.navigationItem setHidesBackButton:YES];
	
	UIButton * cancelButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeDone];
	[cancelButton addTarget:self action:@selector(cancelSheet) forControlEvents:UIControlEventTouchUpInside];
	

	UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	
	self.navigationItem.leftBarButtonItem  = cancel;
	[cancel release];
	
	[super viewDidLoad];
}

- (void)cancelSheet
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
