//
//  GMRGameLobbyController.m
//  Gamer
//
//  Created by Adam Venturella on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRGameLobbyController.h"
#import "UIButton+GMRButtonTypes.h"
#import "GMRLabel.h"
#import "GMRGlobals.h"
#import "GMRClient.h"


@implementation GMRGameLobbyController
@synthesize filterCheveron;

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
    self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Lobby"];
	
	UIImageView * navigationBarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBarBackgroundShadow.png"]];
	navigationBarShadow.frame         = CGRectMake(0, 64, 320.0, 9.0);
	
	[self.navigationController.view addSubview:navigationBarShadow];
	[navigationBarShadow release];
	
	UIButton * filtersButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeFilters];
	[filtersButton addTarget:self action:@selector(editLobbyFilters) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * filters = [[UIBarButtonItem alloc] initWithCustomView:filtersButton];
	
	[self.navigationItem setRightBarButtonItem:filters animated:YES];
	[filters release];
	
	
	filterCheveron.transform = CGAffineTransformMakeTranslation(-60,0);
	[kGamerApi matchesScheduledForPlatform:GMRPlatformXBox360 
						   andTimeInterval:GMRTimeInterval15Min 
							  withCallback:^(BOOL ok, NSDictionary * response){
							  }];
	
	[super viewDidLoad];
}

- (void)editLobbyFilters
{
	
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
