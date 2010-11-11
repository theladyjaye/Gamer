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
#import "HazGame.h"


@implementation GMRAuthenticationController
@synthesize defaultImageView;

- (void)viewDidAppear:(BOOL)animated
{
	static BOOL needsTransition = YES;
	if(needsTransition)
	{
		needsTransition = NO;
		
		inputController = [[GMRAuthenticationInputController alloc] initWithNibName:nil bundle:nil];
		
		dispatch_time_t delay;
		delay = dispatch_time(DISPATCH_TIME_NOW, 100000000);
		dispatch_after(delay, dispatch_get_main_queue(), ^{
			
			[inputController viewWillAppear:YES];
			
			[self.view addSubview:inputController.view];

			[UIView transitionFromView:defaultImageView
								toView:inputController.view
							  duration:0.8f
							   options:UIViewAnimationOptionTransitionFlipFromRight
							completion:^(BOOL finished){
								[inputController viewDidAppear:YES];
								inputController.authenticationController = self;
							}];
		});
		
		
	}
}

- (void)authenticationDidSucceed
{	
	[inputController viewWillDisappear:YES];
	
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
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.defaultImageView = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
