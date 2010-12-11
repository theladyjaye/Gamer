//
//  GMRProfileController.m
//  Gamer
//
//  Created by Adam Venturella on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRProfileController.h"
#import "GMRProfileController+AliasTable.h"
#import "GMRLabel.h"
#import "UIButton+GMRButtonTypes.h"

@implementation GMRProfileController
@synthesize navigationBar, aliasTableView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/



- (void)viewDidLoad 
{
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Profile"];
	[self.navigationItem setHidesBackButton:YES];
	
	UIButton * addAliasButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeAdd];
	[addAliasButton addTarget:self action:@selector(addAlias) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * addAlias = [[UIBarButtonItem alloc] initWithCustomView:addAliasButton];
	
	[self.navigationItem setRightBarButtonItem:addAlias animated:YES];
	[addAlias release];
	
	
	[self.navigationBar setItems:[NSArray arrayWithObject:self.navigationItem]];
	
	UIImageView * navigationBarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBarBackgroundShadow.png"]];
	navigationBarShadow.frame         = CGRectMake(0, 44, 320.0, 9.0);

	[self.view addSubview:navigationBarShadow];
	[navigationBarShadow release];
	
	[self aliasTableRefresh];
	[super viewDidLoad];
}


- (void)addAlias
{
	// modal
}

- (IBAction) performAction:(id)sender
{
	NSUInteger tag = [sender tag];
	
	switch(tag)
	{
		case 0: // someone took my alias
			NSLog(@"dispute");
			break;
			
		case 1: // request a game
			NSLog(@"request");
			break;
			
		case 2: // logout
			NSLog(@"logout");
			break;
			
	}
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.navigationBar = nil;
	self.aliasTableView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[aliases release];
	aliases = nil;
    [super dealloc];
}


@end
