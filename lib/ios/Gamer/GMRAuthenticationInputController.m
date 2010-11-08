//
//  GMRAuthenticationInputController.m
//  Gamer
//
//  Created by Adam Venturella on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRAuthenticationInputController.h"
#import "GMRAuthenticationController.h"

@implementation GMRAuthenticationInputController
@synthesize username, password;

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)authenticate
{
	NSString * usernameString = self.username.text;
	NSString * passwordString = self.password.text;
	
	NSLog(@"%@ : %@", usernameString, passwordString);
	[self authenticationDidSucceedWithUsername:@"foo" andToken:@"bar"];
	
}

- (void)authenticationDidSucceedWithUsername:(NSString *)name andToken:(NSString *)token;
{
	//NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	//[defaults setObject:name forKey:@"username"];
	//[defaults setObject:token forKey:@"token"];
	
	GMRAuthenticationController * parentController = (GMRAuthenticationController *) self.parentViewController;
	[parentController authenticationDidSucceed];
}

- (void)authenticationDidFail
{

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

- (void)viewDidAppear:(BOOL)animated
{
	[self.username becomeFirstResponder];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	self.username = nil;
	self.password = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
