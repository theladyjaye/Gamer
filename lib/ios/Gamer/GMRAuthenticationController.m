//
//  GMRAuthenticationController.m
//  Gamer
//
//  Created by Adam Venturella on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#include <dispatch/dispatch.h>
#import "GMRAuthenticationController.h"
#import "GMRAuthenticationInputController.h"
#import "GMRNavigationController.h"
#import "GMRLabel.h"
#import "HazGame.h"


@implementation GMRAuthenticationController
@synthesize defaultImageView, gmrNavigationController, toolbar;

- (void)viewDidLoad
{
	toolbar              = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 220, 320, 44)];
	toolbar.transform    = CGAffineTransformMakeTranslation(0.0, 44);
	toolbar.hidden       = YES;
	
	[gmrNavigationController.view addSubview:toolbar];
	
	[super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated
{
	if(hasTransitioned == NO)
	{
		hasTransitioned = YES;
		
		inputController = [[GMRAuthenticationInputController alloc] initWithNibName:nil bundle:nil];
		
		dispatch_time_t delay;
		
		// this animation was not running until this was added
		delay = dispatch_time(DISPATCH_TIME_NOW, 100000000);
		dispatch_after(delay, dispatch_get_main_queue(), ^{
			
			inputController.authenticationController = self;
			[inputController viewWillAppear:YES];
			
			[self.view addSubview:inputController.view];

			[UIView transitionFromView:defaultImageView
								toView:inputController.view
							  duration:0.8f
							   options:UIViewAnimationOptionTransitionFlipFromRight
							completion:^(BOOL finished){
								[gmrNavigationController setNavigationBarHidden:NO animated:YES];								
								
								self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Welcome"];
								
								// not using the block api for this because we have to
								// set the toolbar to hidden = NO prior to starting.
								// the block API immediately sets the hidden property
								[UIView beginAnimations:@"toolbarTransitionIn" context:nil];
								[UIView setAnimationDelay:0.5];
								[UIView setAnimationDuration:0.25];
								[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
								[UIView setAnimationWillStartSelector:@selector(toolbarAnimationWillStart:context:)];
								[UIView setAnimationDelegate:self];
								
								 toolbar.transform = CGAffineTransformIdentity;
								
								[UIView commitAnimations];
								
								/*
								[UIView animateWithDuration:0.25 
													  delay:0.21 
													options:UIViewAnimationCurveEaseOut 
												 animations:^{
													 toolbar.hidden = NO;
													 toolbar.transform = CGAffineTransformIdentity;
												 } 
												 completion:NULL];
								 */
								
								[inputController viewDidAppear:YES];
							}];
		});
		
		
	}
}

- (void)toolbarAnimationWillStart:(NSString *)animationID context:(void *)context
{
	toolbar.hidden = NO;
}


- (void)authenticationDidSucceed
{	
	[UIView animateWithDuration:0.25 
					 animations:^{
						 toolbar.transform    = CGAffineTransformMakeTranslation(0.0, 47);
					 } 
					 completion:^(BOOL finished){
						 toolbar.hidden = YES;
						 [inputController viewWillDisappear:YES];
						 [gmrNavigationController setNavigationBarHidden:YES animated:YES];
						 
						 [UIView transitionFromView:inputController.view
											 toView:defaultImageView
										   duration:0.8f
											options:UIViewAnimationOptionTransitionFlipFromLeft
										 completion:^(BOOL finished){
											 
											 [inputController viewDidDisappear:YES];
											 [inputController release];
											 inputController = nil;
											 
											 HazGame * app = (HazGame *)[[UIApplication sharedApplication] delegate];
											 [app performSelector:@selector(initializeApplicationFlow) withObject:app afterDelay:0.15];
										 }];
					 }];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.defaultImageView = nil;
	[toolbar release];
}


- (void)dealloc {
	
    [super dealloc];
}


@end
