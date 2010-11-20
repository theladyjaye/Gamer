//
//  GMRMainController.m
//  Gamer
//
//  Created by Adam Venturella on 11/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRMainController.h"
#import "GMRGlobals.h"

static UINavigationController * currentNavigationController;

@implementation GMRMainController
@synthesize tabBarController, defaultImageView;

- (IBAction)newMatch:(id)sender
{
	NSLog(@"Add Match!");
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	UINavigationController * navController = [self.tabBarController.viewControllers objectAtIndex:0];
	UINavigationBar * navigationBar = navController.navigationBar;
	
	[self.view addSubview:tabBarController.view];
	[self.tabBarController.view insertSubview:self.defaultImageView atIndex:1];
	tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0.0, 49.0);
	
	navigationBar.transform = CGAffineTransformMakeTranslation(0.0, -44.0);
	[super viewDidLoad];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidAppear:(BOOL)animated
{
	[UIView transitionWithView:self.defaultImageView 
					  duration:0.35f 
					   options:UIViewAnimationOptionCurveEaseInOut 
					animations:^{
						self.defaultImageView.transform = CGAffineTransformMakeTranslation(-1 * self.defaultImageView.frame.size.width, 0.0);
					} 
					completion:^(BOOL finished){
						[self.defaultImageView removeFromSuperview];
						self.defaultImageView = nil;
					}];
	
	UINavigationController * navController = [self.tabBarController.viewControllers objectAtIndex:0];
	UINavigationBar * navigationBar = navController.navigationBar;
	
	[UIView beginAnimations:@"tabBarTransition" context:nil];
	[UIView setAnimationDelay:0.15];
	[UIView setAnimationDuration:0.25];
	self.tabBarController.tabBar.transform = CGAffineTransformIdentity;
	navigationBar.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    self.tabBarController = nil;
	self.defaultImageView = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
