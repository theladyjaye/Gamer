//
//  GMRAuthenticationInputController.m
//  Gamer
//
//  Created by Adam Venturella on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#include <dispatch/dispatch.h>
#import "GMRAuthenticationInputController.h"
#import "GMRAuthenticationController.h"
#import "GMRAuthenticationNewAccount.h"
#import "GMRAlertView.h"
#import "GMRGlobals.h"
#import "GMRClient.h"
#import "UIButton+GMRButtonTypes.h"

@implementation GMRAuthenticationInputController
@synthesize username, password, authenticationController;

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)newAccount
{
	GMRAuthenticationNewAccount * newAccountController = [[GMRAuthenticationNewAccount alloc] initWithNibName:nil bundle:nil];
	newAccountController.inputController = self;
	[newAccountController viewWillAppear:YES];
	[self.authenticationController.gmrNavigationController pushViewController:newAccountController animated:YES];
	[newAccountController release];
	
}

- (void)authenticate
{
	NSString * usernameString = self.username.text;
	NSString * passwordString = self.password.text;
	
	// both of these methods will be invoked from a background thread
	[kGamerApi authenticateUser:usernameString password:passwordString withCallback:^(BOOL ok, NSDictionary * response){
		
		if(ok)
		{
			NSString * token = (NSString *)[response objectForKey:@"token"];
			kGamerApi.username = usernameString;
			kGamerApi.apiKey   = token;
			[self authenticationDidSucceedWithUsername:usernameString andToken:token];
		}
		else 
		{
			[self authenticationDidFail];
		}

	}];
}

- (void)authenticationDidSucceedWithUsername:(NSString *)name andToken:(NSString *)token;
{
	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:name forKey:@"username"];
	[defaults setObject:token forKey:@"token"];
	
	// because this will affect the ui thread (the transition), 
	// we need to be sure it's called from the main thread	
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.authenticationController authenticationDidSucceed];
	});
	
	
	//SEL command = @selector(authenticationDidSucceed);
	//NSInvocation* invocation     = [NSInvocation invocationWithMethodSignature:[self.parentViewController methodSignatureForSelector:command]];
	//[invocation setTarget:self.parentViewController];
	//[invocation setSelector:command];
	
	//[invocation performSelectorOnMainThread:@selector(invoke) withObject:NULL waitUntilDone:NO];	
}

- (void)authenticationDidFail
{
	dispatch_async(dispatch_get_main_queue(), ^{
		GMRAlertView * alert = [[GMRAlertView alloc] initWithTitle:@"Error" 
														   message:@"Invalid Username or Password" 
														  delegate:self];
		[alert show];
	});
	
	
}


- (void)alertViewDidDismiss:(GMRAlertView *)alertView
{
	[alertView release];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if(textField == self.username)
	{
		[self.password becomeFirstResponder];
		
	}
	else 
	{
		[self.username becomeFirstResponder];
	}
	
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
	UIButton* newAccountButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeNewAccount];
	[newAccountButton addTarget:self action:@selector(newAccount) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton* loginButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeLogin];
	[loginButton addTarget:self action:@selector(authenticate) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * newAccount = [[UIBarButtonItem alloc] initWithCustomView:newAccountButton];
	UIBarButtonItem * spacer     = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem * login      = [[UIBarButtonItem alloc] initWithCustomView:loginButton];
	
	
	
	NSArray * items = [NSArray arrayWithObjects:newAccount, spacer, login, nil];
	[authenticationController.toolbar setItems:items animated:YES];
	
	[newAccount release];
	[spacer release];
	[login release];
	
	
	if(self.username)
	{
		self.username.text = @"";
		self.password.text = @"";
		[self.username becomeFirstResponder];
	}
	
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[self.username becomeFirstResponder];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	self.username = nil;
	self.password = nil;
	self.authenticationController = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
