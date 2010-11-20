//
//  GMRGameDetailController.m
//  Gamer
//
//  Created by Adam Venturella on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <dispatch/dispatch.h>
#import "GMRGameDetailController.h"
#import "GMRGameDetailController+PlayerList.h"
#import "GMRButton.h"
#import "GMRPlatformBanner.h"
#import "GMRGlobals.h"
#import "NSDate+JSON.h"
#import "GMRTypes.h"
#import "GMRAlertView.h"

@implementation GMRGameDetailController
@synthesize playersTableView, playersForMatch, platformBanner, gameLabel, descriptionLabel, modeLabel, scheduleTimeLabel;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super initWithNibName:nil bundle:nil];
	if(self)
	{
		match = dictionary;
		[match retain];
	}
	
	return self;
}
- (void)viewDidLoad 
{	
	// cell height is set to 92 - Image components = 91 + 1 for seperator
	//tableView.separatorColor = [UIColor blackColor];

	self.navigationItem.title = @"Details";
	
	NSDictionary * gameData = [match objectForKey:@"game"];
	GMRPlatform platform    = [kGamerApi platformForString:[gameData objectForKey:@"platform"]];
	
	platformBanner.platform = platform;
	
	
	gameLabel.text         = [gameData objectForKey:@"label"];
	descriptionLabel.text  = [match objectForKey:@"label"];
	modeLabel.text         = [match objectForKey:@"mode"];
	scheduleTimeLabel.text = [NSDate gamerScheduleTimeString:[match objectForKey:@"scheduled_time"]];
	
	NSString * currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	
	if ([[match objectForKey:@"created_by"] isEqualToString:currentUser]) 
	{
		actionButton = [[GMRButton alloc] initWithStyle:GMRButtonStyleRed 
												  label:@"Cancel Game" 
												 target:self 
												 action:@selector(cancelGame)];
	}
	else 
	{
		actionButton = [[GMRButton alloc] initWithStyle:GMRButtonStyleYellow 
												  label:@"Leave Game" 
												 target:self 
												 action:@selector(leaveGame)];
	}
	
	shareButton = [[GMRButton alloc] initWithStyle:GMRButtonStyleGray
											  label:@"Share Game" 
											 target:self 
											 action:@selector(shareGame)];
	
	shareButton.frame  = CGRectMake(3.0, 278.0, shareButton.frame.size.width, shareButton.frame.size.height);
	actionButton.frame = CGRectMake(shareButton.frame.origin.x, (shareButton.frame.origin.y + shareButton.frame.size.height) + 3.0, actionButton.frame.size.width, actionButton.frame.size.height);
	
	shareButton.transform = CGAffineTransformMakeTranslation(0.0, 39.0);
	actionButton.transform = CGAffineTransformMakeTranslation(0.0, 39.0);
	
	shareButton.alpha  = 0.0;
	actionButton.alpha = 0.0;
	
	[self.view addSubview:shareButton];
	[self.view addSubview:actionButton];
	
	[self playersTableRefresh];
	
	[super viewDidLoad];
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[UIView animateWithDuration:0.23
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 shareButton.alpha      = 1.0;
						 shareButton.transform  = CGAffineTransformIdentity; 
					 } 
					 completion:NULL];
	
	[UIView animateWithDuration:0.23
						  delay:0.05
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 actionButton.alpha     = 1.0;
						 actionButton.transform = CGAffineTransformIdentity;
					 } 
					 completion:NULL];
}

-(void)shareGame
{
	
}

-(void)cancelGame
{
	GMRAlertView * alert = [[GMRAlertView alloc] initWithStyle:GMRAlertViewStyleConfirmation
														 title:@"Cancel Game?" 
													   message:@"Are you sure you wish to cancel this game?" 
													  delegate:self];
	[alert show];
	
	
}

-(void)leaveGame
{
	GMRAlertView * alert = [[GMRAlertView alloc] initWithStyle:GMRAlertViewStyleConfirmation
														 title:@"Leave Game?" 
													   message:@"Are you sure you wish to leave this game?" 
													  delegate:self];
	[alert show];
}

- (void)alertViewDidDismiss:(GMRAlertView *)alertView
{

	if(alertView.selectedButtonIndex == 1)
	{
		 NSDictionary * gameData = [match objectForKey:@"game"];
		 
		 GMRPlatform platform = platformBanner.platform;
		 NSString * gameId    = [[[gameData objectForKey:@"id"] componentsSeparatedByString:@"/"] objectAtIndex:1];
		 NSString * matchId   = [match objectForKey:@"_id"];
		 [kGamerApi matchLeave:platform gameId:gameId matchId:matchId withCallback:^(BOOL ok, NSDictionary * response){
			 dispatch_async(dispatch_get_main_queue(), ^{
				 
				 NSUInteger previousIndex              = ([[self.navigationController viewControllers] indexOfObject:self] -1);
				 UIViewController * previousController = [[self.navigationController viewControllers] objectAtIndex:previousIndex];
				 
				 [previousController performSelector:@selector(matchesTableRefresh)];
				 [self.navigationController popViewControllerAnimated:YES];
			 });
		 }];
	}
	
	[alertView release];
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
	
	self.playersTableView = nil;
	self.gameLabel = nil; 
	self.descriptionLabel = nil;
	self.modeLabel = nil;
	self.scheduleTimeLabel = nil;
}


- (void)dealloc {
	self.playersForMatch = nil;
	[shareButton release];
	[actionButton release];
	[match release];
    [super dealloc];
}


@end
