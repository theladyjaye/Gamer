//
//  GMRChoosePlatformController.m
//  Gamer
//
//  Created by Adam Venturella on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRChoosePlatformController.h"
#import "GMRMatch.h"
#import "GMRTypes.h"
#import "GMRCreateGameGlobals.h"

@implementation GMRChoosePlatformController

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
    self.navigationItem.title = @"Choose Platform";
	[super viewDidLoad];
}

- (IBAction)selectBattleNet
{
	kCreateMatchProgress.platform = GMRPlatformBattleNet;
}

- (IBAction)selectPlaystation2
{
	kCreateMatchProgress.platform = GMRPlatformPlaystation2;
}

- (IBAction)selectPlaystation3
{
	kCreateMatchProgress.platform = GMRPlatformPlaystation3;
}
- (IBAction)selectWii
{
	kCreateMatchProgress.platform = GMRPlatformWii;
}

- (IBAction)selectXbox360
{
	kCreateMatchProgress.platform = GMRPlatformXBox360;
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
}


- (void)dealloc {
    [super dealloc];
}


@end
