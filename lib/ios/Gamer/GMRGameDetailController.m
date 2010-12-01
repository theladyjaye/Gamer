//
//  GMRGameDetailController.m
//  Gamer
//
//  Created by Adam Venturella on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <dispatch/dispatch.h>
#import <QuartzCore/QuartzCore.h>
#import "GMRGameDetailController.h"
#import "GMRGameDetailController+PlayerList.h"
#import "GMRButton.h"
#import "GMRGlobals.h"
#import "GMRClient.h"
#import "NSDate+JSON.h"
#import "GMRTypes.h"
#import "GMRAlertView.h"
#import "GMRMatch.h"
#import "GMRGame.h"
#import "GMRLabel.h"
#import "UIButton+GMRButtonTypes.h"

@implementation GMRGameDetailController
@synthesize playersTableView, playersForMatch, gameLabel, platformLabel, descriptionLabel, modeLabel, scheduleTimeLabel, howItWorksView;

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
	howItWorksView.transform = CGAffineTransformMakeTranslation(0.0, 100);
	
	CGFloat roundedColor = 246.0/255.0;
	UIView * roundedView = [[UIView alloc] initWithFrame:CGRectMake(4.0, 8.0, 312.0, 68.0)];
	
	
	roundedView.layer.cornerRadius    = 5.0;
	roundedView.layer.backgroundColor = [UIColor colorWithRed:roundedColor 
										            green:roundedColor 
										             blue:roundedColor 
										            alpha:1.0].CGColor;
	
	
	[howItWorksView insertSubview:roundedView atIndex:0];
	[roundedView release];
	howItWorksView.hidden = YES;
	
	
	[self.view addSubview:toolbar];
	
	
	
	gameLabel.text         = match.game.label;
	descriptionLabel.text  = match.label;
	modeLabel.text         = match.mode;
	scheduleTimeLabel.text = [NSDate relativeTime:match.scheduled_time];
	platformLabel.text     = [GMRClient displayNameForPlatform:match.platform];
	
	UIView * platformColors = [[UIView alloc] initWithFrame:CGRectMake(0, (descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height), 320, 6)];
	UIColor * patternColor;
	
	switch(match.platform)
	{
		case GMRPlatformBattleNet:
			patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PlatformColorHorizontalBattleNet.png"]];
			break;
			
		case GMRPlatformPlaystation2:
			patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PlatformColorHorizontalPlaystation2.png"]];
			break;
			
		case GMRPlatformPlaystation3:
			patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PlatformColorHorizontalPlaystation3.png"]];
			break;
			
		case GMRPlatformSteam:
			patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PlatformColorHorizontalSteam.png"]];
			break;
			
		case GMRPlatformWii:
			patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PlatformColorHorizontalWii.png"]];
			break;
			
		case GMRPlatformXBox360:
			patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PlatformColorHorizontalXbox360.png"]];
			break;
			
	}
	
	platformColors.backgroundColor = patternColor;
	
	[self.view addSubview:platformColors];
	[platformColors release];
	
	
	[self playersTableRefresh];
	
	[super viewDidLoad];
	 
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[updateTimer invalidate];
	/*
	[self.navigationController setToolbarHidden:YES animated:YES];
	
	[UIView animateWithDuration:0.15
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 toolbar.transform    = CGAffineTransformMakeTranslation(0.0, 44);
						 howItWorksView.transform = CGAffineTransformMakeTranslation(0.0, 84 + 44);
					 } 
					 completion:NULL];
	 */
}

- (void)viewDidAppear:(BOOL)animated
{
	[UIView animateWithDuration:0.15
						  delay:0.15
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 
					 } 
					 completion:^(BOOL finished){
						 
					 }];
	
	[UIView animateWithDuration:0.25
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 
						 toolbar.transform  = CGAffineTransformIdentity; 
					 } 
					 completion:^(BOOL finished){
						 
						 NSString * currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
						 
						 UIButton * actionButton;
						 
						 if([match.created_by isEqualToString:currentUser])
						 {
							 actionButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeCancel];
							 [actionButton addTarget:self action:@selector(cancelGame) forControlEvents:UIControlEventTouchUpInside];
						 }
						 else
						 {
							 actionButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeLeave];
							 [actionButton addTarget:self action:@selector(leaveGame) forControlEvents:UIControlEventTouchUpInside];
						 }
						 
						 
						 UIButton* shareButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeShare];
						 [shareButton addTarget:self action:@selector(shareGame) forControlEvents:UIControlEventTouchUpInside];
						 
						 UIBarButtonItem * action = [[UIBarButtonItem alloc] initWithCustomView:actionButton];
						 UIBarButtonItem * spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
						 UIBarButtonItem * share = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
						 
						 NSArray * items = [NSArray arrayWithObjects:action, spacer, share, nil];
						 
						 [toolbar setItems:items animated:YES];
						 
						 howItWorksView.hidden = NO;
						[UIView animateWithDuration:0.3
											   delay:0.0
											 options:UIViewAnimationOptionCurveEaseOut
										  animations:^{
											  howItWorksView.transform = CGAffineTransformIdentity;
											  updateTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 
																							 target:self 
																						   selector:@selector(updateCountdown) 
																						   userInfo:nil 
																							repeats:YES];
										  } 
										  completion:NULL];
					}];
}

-(void)updateCountdown
{
	NSLog(@"Updating detail countdown");
	self.scheduleTimeLabel.text = [NSDate relativeTime:match.scheduled_time];
}


-(void)shareGame
{
	
}


-(void)cancelGame
{
	GMRAlertView * alert = [[GMRAlertView alloc] initWithStyle:GMRAlertViewStyleConfirmation
														 title:@"Cancel Game?" 
													   message:@"This is a serious moment. Are you sure you wish to cancel this game? All players will be removed and the game deleted." 
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
	self.platformLabel = nil;
	self.howItWorksView = nil;
	
	[toolbar release];
}


- (void)dealloc {
	self.playersForMatch = nil;
	[match release];
    [super dealloc];
}


@end
