//
//  GMRGameLobbyController.m
//  Gamer
//
//  Created by Adam Venturella on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRGameLobbyController.h"
#import "UIButton+GMRButtonTypes.h"
#import "GMRGameLobbyController+TableView.h"
#import "GMRGameLobbyGlobals.h"
#import "GMRLobbyFiltersController.h"
#import "GMRLabel.h"
#import "GMRTypes.h"
#import "GMRFilter.h"


@implementation GMRGameLobbyController
@synthesize filterCheveron;


- (void)viewDidLoad 
{
	
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Lobby"];
	
	UIImageView * navigationBarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBarBackgroundShadow.png"]];
	navigationBarShadow.frame         = CGRectMake(0, 64, 320.0, 9.0);
	
	[self.navigationController.view addSubview:navigationBarShadow];
	[navigationBarShadow release];
	
	UIButton * filtersButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeFilters];
	[filtersButton addTarget:self action:@selector(editLobbyFilters) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * filters = [[UIBarButtonItem alloc] initWithCustomView:filtersButton];
	
	[self.navigationItem setRightBarButtonItem:filters animated:NO];
	[filters release];
	
	
	filterCheveron.transform = CGAffineTransformMakeTranslation(-60,0);
	
	[self resultsTableRefresh];
	
	
	[super viewDidLoad];
}

- (void)editLobbyFilters
{
	 GMRLobbyFiltersController * controller = [[GMRLobbyFiltersController alloc] initWithNibName:nil
																						  bundle:nil];
	
	controller.owner = self;
	
	 UINavigationController * filterGames    = [[UINavigationController alloc] initWithRootViewController:controller];
	 
	 UIImageView * navigationBarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBarBackgroundShadow.png"]];
	 navigationBarShadow.frame         = CGRectMake(0, 64, 320.0, 9.0);
	 
	 [filterGames.view addSubview:navigationBarShadow];
	 [navigationBarShadow release];
	 
	 
	 [self presentModalViewController:filterGames 
							 animated:YES];
	 [filterGames release];
	 [controller release];
}

- (IBAction)changeTimeFilter:(id)sender
{
	NSInteger tag = [sender tag];
	
	switch(tag)
	{
		case 15:
			[self translateCheveronX:-60];
			break;
		
		case 30:
			[self translateCheveronX:0];
			break;
		
		case 60:
			[self translateCheveronX:60];
			break;
	}
}

- (void)translateCheveronX:(CGFloat)tx
{
	[UIView animateWithDuration:0.2 
						  delay:0.0 
						options:UIViewAnimationCurveEaseOut 
					 animations:^{
						filterCheveron.transform = CGAffineTransformMakeTranslation(tx, 0); 
					 }
					 completion:NULL];
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.filterCheveron = nil;
}


- (void)dealloc {
	self.filterCheveron = nil;
    
	[super dealloc];
}


@end
