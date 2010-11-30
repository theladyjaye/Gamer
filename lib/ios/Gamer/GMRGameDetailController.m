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
#import "GMRMatch.h"
#import "GMRGame.h"
#import "GMRLabel.h"
#import "UIButton+GMRButtonTypes.h"

@implementation GMRGameDetailController
@synthesize playersTableView, playersForMatch, platformBanner, gameLabel, descriptionLabel, modeLabel, scheduleTimeLabel;

-(id)initWithMatch:(GMRMatch *)value;
{
	self = [super initWithNibName:nil bundle:nil];
	if(self)
	{
		match = value;
		[match retain];
	}
	
	return self;
}
- (void)viewDidLoad 
{
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Details"];
	[self.navigationItem setHidesBackButton:YES];
	
	UIButton * backButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeBack];
	[backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	
	[self.navigationItem setLeftBarButtonItem:backItem animated:YES];
	[backItem release];
	
	toolbar              = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 323, 320, 44)];
	toolbar.transform    = CGAffineTransformMakeTranslation(0.0, 44);
	[self.view addSubview:toolbar];
	
	
	/*
	
	platformBanner.platform = match.game.platform;
	
	
	gameLabel.text         = match.game.label;
	descriptionLabel.text  = match.label;
	modeLabel.text         = match.mode;
	scheduleTimeLabel.text = [NSDate gamerScheduleTimeString:match.scheduled_time];
	
	NSString * currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	
	if ([match.created_by isEqualToString:currentUser]) 
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
	*/
	[super viewDidLoad];
	 
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self.navigationController setToolbarHidden:YES animated:YES];
	
	
	[UIView animateWithDuration:0.15
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 toolbar.transform    = CGAffineTransformMakeTranslation(0.0, 44);
					 } 
					 completion:NULL];
}

- (void)viewDidAppear:(BOOL)animated
{
	[UIView animateWithDuration:0.15
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 
						 toolbar.transform  = CGAffineTransformIdentity; 
					 } 
					 completion:^(BOOL finished){
						 
						 UIButton* actionButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeCancel];
						 [actionButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
						 
						 UIButton* shareButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeShare];
						 [shareButton addTarget:self action:@selector(shareGame) forControlEvents:UIControlEventTouchUpInside];
						 
						 UIBarButtonItem * action = [[UIBarButtonItem alloc] initWithCustomView:actionButton];
						 UIBarButtonItem * spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
						 UIBarButtonItem * share = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
						 
						 NSArray * items = [NSArray arrayWithObjects:action, spacer, share, nil];
						 
						 [toolbar setItems:items animated:YES];
					 }];
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
		NSString * gameId    = [[match.game.id componentsSeparatedByString:@"/"] objectAtIndex:1];
		
		 [kGamerApi matchLeave:match.game.platform 
						gameId:gameId 
					   matchId:match.id 
				  withCallback:^(BOOL ok, NSDictionary * response){
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
	
	[toolbar release];
}


- (void)dealloc {
	self.playersForMatch = nil;
	[match release];
    [super dealloc];
}


@end
