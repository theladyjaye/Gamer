//
//  GMRMainController.m
//  Gamer
//
//  Created by Adam Venturella on 11/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRMainController.h"
#import "GMRGlobals.h"
#import "HazGame.h"

static UINavigationController * currentNavigationController;

@implementation GMRMainController
@synthesize tabBarController, defaultImageView;


- (void)viewDidLoad 
{
	UINavigationController * navController = [self.tabBarController.viewControllers objectAtIndex:0];
	UINavigationBar * navigationBar = navController.navigationBar;
	
	[self.view addSubview:tabBarController.view];
	
	// this mkes the tabbar controller actually send the proper events to it's children controllers
	[self.tabBarController viewWillAppear:YES];
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
	// this mkes the tabbar controller actually send the proper events to it's children controllers
	[self.tabBarController viewDidAppear:YES];
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
	
	UIImageView * navigationBarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBarBackgroundShadow.png"]];
	navigationBarShadow.frame         = CGRectMake(0, 64, 320.0, 9.0);
	navigationBarShadow.transform     = CGAffineTransformMakeTranslation(0.0, -64.0);
	
	[navController.view addSubview:navigationBarShadow];
	[navigationBarShadow release];
	
	[UIView animateWithDuration:0.25 
						  delay:0.15 
						options:UIViewAnimationCurveEaseOut 
					 animations:^{
						 self.tabBarController.tabBar.transform = CGAffineTransformIdentity;
						 navigationBar.transform = CGAffineTransformIdentity;
						 navigationBarShadow.transform = CGAffineTransformIdentity;
					 } 
					 completion:NULL];
}

- (void)logout
{
	NSString * path       = [[NSBundle mainBundle] pathForResource:@"Default" ofType:@"png"];
	UIImage * image       = [[UIImage alloc] initWithContentsOfFile:path];
	self.defaultImageView = [[[UIImageView alloc] initWithImage:image] autorelease];
	self.defaultImageView.frame = (CGRect){ {(self.defaultImageView.frame.size.width * -1), self.defaultImageView.frame.origin.y}, self.defaultImageView.frame.size};
	
	[self.view addSubview:self.defaultImageView];
	[image release];
	
	[UIView transitionWithView:self.defaultImageView 
					  duration:0.35f 
					   options:UIViewAnimationOptionCurveEaseInOut 
					animations:^{
						self.defaultImageView.transform = CGAffineTransformMakeTranslation(self.defaultImageView.frame.size.width, 0.0);
					} 
					completion:^(BOOL finished){
						
						// if the main controller is out of the picture, 
						// it means we are dropping back to the autentication view
						HazGame * app = (HazGame *)[UIApplication sharedApplication].delegate;
						[app initializeAuthenticationFlow];
						
						//[self.defaultImageView removeFromSuperview];
						//self.defaultImageView = nil;
					}];
	
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	// this might cause subsequent calls to these methods.
	// there was an issue with the TabBarController not calling view_Will/Did_Appear/Disappear
	// I think I fixed that above, but I don't know what the ramifications for this will be.
	// If you start haveing problems.. start by looing here.
	static UIViewController * lastViewController;
	
	if(lastViewController)
		[lastViewController viewWillDisappear:animated];
	
	lastViewController = viewController;
	[viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[viewController viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload 
{
	self.tabBarController = nil;
	self.defaultImageView = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	
	self.tabBarController = nil;
	self.defaultImageView = nil;	
	[super dealloc];
}


@end
