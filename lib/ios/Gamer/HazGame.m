//
//  HazGame.m
//  Gamer
//
//  Created by Adam Venturella on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <dispatch/dispatch.h>
#import "HazGame.h"
#import "GMRGlobals.h"
#import "GMRClient.h"
#import "GMRAuthenticationController.h"
#import "GMRMainController.h"
#import "GMRNavigationController.h"
#import "GMRActivityView.h"
#import "UIApplication+GamePop.h"
#import "OverviewController.h"
#import "GMRAlertView.h"

GMRClient * kGamerApi = nil;
NSMutableArray * kScheduledMatches = nil;
OverviewController * kScheduledMatchesViewController = nil;

@implementation HazGame
@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	if([self hasAuthenticatedUser])
	{
		if(!kGamerApi)
		{
			// make sure this token is valid...
			// because this will take an unknown amount of time
			// don't let the user see anything weird...
			
			NSString * path = [[NSBundle mainBundle] pathForResource:@"Default" ofType:@"png"];
			UIImageView * defaultImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
			
			[self.window addSubview:defaultImage];
			
			NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
			kGamerApi = [[GMRClient alloc] initWithKey:[defaults objectForKey:@"token"] 
											   andName:[defaults objectForKey:@"username"]];
			
			[kGamerApi version:^(BOOL ok, NSDictionary * response){
				
				dispatch_async(dispatch_get_main_queue(), ^{
					if(ok == NO)
					{
						[kGamerApi release];
						kGamerApi = nil;
						
						[defaultImage removeFromSuperview];
						
						[defaults removeObjectForKey:@"token"];
						[defaults removeObjectForKey:@"username"];
						
						[self initializeAuthenticationFlow];
					}
					else 
					{
						[defaultImage removeFromSuperview];
						[self initializeApplicationFlow];
					}
					
					[defaultImage release]; 
				});
			}];
		}
		
		//[self initializeApplicationFlow];
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
	if(!kGamerApi)
	{
		kGamerApi = [[GMRClient alloc] init];
	}
	
	if(mainController)
	{
		[mainController.view removeFromSuperview];
		[mainController viewDidUnload];
		[mainController release];
		mainController = nil;
		
		if(kScheduledMatches)
		{
			[kScheduledMatches release];
			kScheduledMatches = nil;
		}
	}
	
	
	GMRAuthenticationController * loginController = [[GMRAuthenticationController alloc] initWithNibName:nil bundle:nil];
	
	authenticationController = [[GMRNavigationController alloc] initWithRootViewController:loginController];
	loginController.gmrNavigationController = authenticationController;
	
	
	[authenticationController setNavigationBarHidden:YES animated:NO];
	[loginController release];
	
	//[authenticationController viewWillAppear:YES];
	[self.window addSubview:authenticationController.view];
	//[authenticationController viewDidAppear:YES];
	
}

- (void)initializeApplicationFlow
{	
	// this guy is going to hang around for the lifetime of the application.
	// should save us form makeing lot-o-GETs for the same data.
	//kScheduledMatches = [NSMutableArray array];
	//[kScheduledMatches retain];
	
	mainController = [[GMRMainController alloc] initWithNibName:nil bundle:nil];
	
	//[mainController viewWillAppear:YES];
	[self.window addSubview:mainController.view];
	//[mainController viewDidAppear:YES];
	
	if(authenticationController)
	{
		[authenticationController.view removeFromSuperview];
		[authenticationController release];
		authenticationController = nil;
	}
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


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	
	NSString * token = [[[[deviceToken description]
						 stringByReplacingOccurrencesOfString: @"<" withString: @""] 
						 stringByReplacingOccurrencesOfString: @">" withString: @""] 
					     stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	
	if ([application enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) 
	{
		// should we unregister the token here?
		NSLog(@"Notifications are disabled for this application. Not registering with Urban Airship");
		return;
	}
	
	else 
	{
		NSTimeZone * currentTimeZone = [NSTimeZone localTimeZone];
		
		NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
		NSDictionary * payload    = [NSDictionary dictionaryWithObjectsAndKeys:[defaults objectForKey:@"username"], @"alias", [currentTimeZone name], @"tz", nil];
		
		[kGamerApi registerForPushNotifictions:token payload:payload withCallback:^(BOOL ok, NSDictionary * response){
		
			if(ok)
			{
				NSLog(@"Registered For Push Notifications");
			}
		}];
		 
		
	}

	
	
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	NSLog(@"%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	NSDictionary * aps = [userInfo objectForKey:@"aps"];
	
	NSString * message = [aps objectForKey:@"alert"];
	NSString * title   = @"GamePop";
	
	if([message rangeOfString:@"[Joined]"].location != NSNotFound) 
	{
		title = @"Player Joined";
		message = [message substringFromIndex:8];
	}
	else if([message rangeOfString:@"[Left]"].location != NSNotFound)
	{
		title = @"Player Left";
		message = [message substringFromIndex:6];
	}
	else if([message rangeOfString:@"[Cancelled]"].location != NSNotFound)
	{
		title = @"Game Cancelled";
		message = [message substringFromIndex:11];
	}
	
	
	GMRAlertView * alert = [[GMRAlertView alloc] initWithStyle:GMRAlertViewStyleNotification 
														 title:title 
													   message:message 
													  callback:^(GMRAlertView *alertView) {
														  [alertView release];
													  }];
	
	[alert show];
	
	//NSLog(@"Received notification: %@", [userInfo objectForKey:@"aps"]);
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
