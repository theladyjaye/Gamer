//
//  HazGame.m
//  Gamer
//
//  Created by Adam Venturella on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HazGame.h"
#import "GMRGlobals.h"
#import "GMRClient.h"
#import "GMRAuthenticationController.h"
#import "GMRMainController.h"
#import "GMRNavigationController.h"
#import "GMRActivityView.h"

GMRClient * kGamerApi = nil;

@implementation HazGame
@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	if([self hasAuthenticatedUser])
	{
		[self initializeApplicationFlow];
	}
	else 
	{
		[self initializeAuthenticationFlow];
	}
	
	
	[self.window makeKeyAndVisible];
    return YES;
}

- (void)initializeAuthenticationFlow
{
	kGamerApi = [[GMRClient alloc] init];
	GMRAuthenticationController * loginController = [[GMRAuthenticationController alloc] initWithNibName:nil bundle:nil];
	
	authenticationController = [[GMRNavigationController alloc] initWithRootViewController:loginController];
	loginController.gmrNavigationController = authenticationController;
	
	[authenticationController setNavigationBarHidden:YES animated:NO];
	[self.window addSubview:authenticationController.view];
	
}

- (void)initializeApplicationFlow
{
	if(!kGamerApi)
	{
		NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
		kGamerApi = [[GMRClient alloc] initWithKey:[defaults objectForKey:@"token"] 
										   andName:[defaults objectForKey:@"username"]];
	}
	
	
	mainController = [[GMRMainController alloc] initWithNibName:nil bundle:nil];
	
	[self.window addSubview:mainController.view];
	
	if(authenticationController)
	{
		[authenticationController.view removeFromSuperview];
		[authenticationController release];
		authenticationController = nil;
	}
	
	//NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	//[defaults removeObjectForKey:@"token"];
	//[defaults removeObjectForKey:@"username"];
}




- (BOOL) hasAuthenticatedUser
{
	BOOL result = NO;
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	if([defaults objectForKey:@"token"] != nil && [defaults objectForKey:@"username"] != nil)
	{
		result = YES;
	}
	
	return result;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
