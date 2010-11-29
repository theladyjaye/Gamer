//
//  GMRAuthenticationNewAccount.m
//  Gamer
//
//  Created by Adam Venturella on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#include <dispatch/dispatch.h>
#import "GMRAuthenticationNewAccount.h"
#import "GMRAuthenticationInputController.h"
#import "GMRAuthenticationController.h"
#import "GMRFormatter.h"
#import "GMREmailFormatter.h"
#import "GMRUsernameFormatter.h"
#import "GMRPasswordFormatter.h"
#import "GMRGlobals.h"
#import "GMRClient.h"
#import "GMRAlertView.h"
#import "GMRLabel.h"
#import "UIButton+GMRButtonTypes.h"

@implementation GMRAuthenticationNewAccount
@synthesize inputController, email, username, password, passwordConfirm;
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)viewDidLoad
{
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"New Account"];
	[self.navigationItem setHidesBackButton:YES];
	
	UIButton* cancelButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeCancel];
	[cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton* createButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeCreate];
	[createButton addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	UIBarButtonItem * spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem * create = [[UIBarButtonItem alloc] initWithCustomView:createButton];
	
	NSArray * items = [NSArray arrayWithObjects:cancel, spacer, create, nil];
	[self.inputController.authenticationController.toolbar setItems:items animated:YES];
	
	[cancel release];
	[spacer release];
	[create release];
	
	[email becomeFirstResponder];
	
	[super viewDidLoad];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	/*
	if(textField == password)
	{
		[UIView transitionWithView:self.form 
						  duration:0.35 
						   options:UIViewAnimationOptionCurveEaseOut 
						animations:^{
							self.form.transform = CGAffineTransformMakeTranslation(0.0, -80.0);
						} 
						completion:NULL];
	}
	else if(textField == passwordConfirm)
	{
		[UIView transitionWithView:self.form 
						  duration:0.35 
						   options:UIViewAnimationOptionCurveEaseOut 
						animations:^{
							self.form.transform = CGAffineTransformMakeTranslation(0.0, -135.0);
						} 
						completion:NULL];
	}
	else if(textField == username && self.form.transform.ty != 0)
	{
		[UIView transitionWithView:self.form 
						  duration:0.35
						   options:UIViewAnimationOptionCurveEaseOut 
						animations:^{
							self.form.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
						} 
						completion:NULL];
	}
	*/
	
	
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	
	GMRFormatter * formatter;
	NSString * value = nil;

	if(range.length != 1 && ![string isEqualToString:@""])
	{
		if(textField == email)
		{
			formatter = [[[GMREmailFormatter alloc] init] autorelease];
			formatter.onInvalidCharacter = ^{AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);};
			value  = [formatter stringForObjectValue:string];
		}
		
		if(textField == username)
		{
			formatter = [[[GMRUsernameFormatter alloc] init] autorelease];
			formatter.onInvalidCharacter = ^{AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);};
			value  = [formatter stringForObjectValue:string];
		}
		
		if(textField == passwordConfirm || textField == password)
		{
			formatter = [[[GMRPasswordFormatter alloc] init] autorelease];
			formatter.onInvalidCharacter = ^{AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);};
			value  = [formatter stringForObjectValue:string];
		}
		
		return value != nil;
	}
	
	return YES;
}

- (void)cancel
{
	[self transitionOut];
}

- (void)create
{
	
	[kGamerApi registerUser:email.text 
				   username:username.text 
				   password:password.text 
			 passwordVerify:passwordConfirm.text 
			   withCallback:^(BOOL ok, NSDictionary * response){
				   
				   if(YES)//ok)
				   {
					   dispatch_async(dispatch_get_main_queue(), ^{
						   [self createSucceeded];
					   });
				   }
				   else 
				   {
					   dispatch_async(dispatch_get_main_queue(), ^{
						   [self createFailedWithErrors:[response objectForKey:@"errors"]];
					   });
				   }

			   }];
}
- (void)createFailedWithErrors:(NSArray *)errors
{
	GMRAlertView * alert = [[GMRAlertView alloc] initWithStyle:GMRAlertViewStyleNotification
														 title:@"Error" 
													   message:@"Form Error"
													  callback:^(GMRAlertView * alertView){
														  [alertView release];
													  }];
	[alert show];
}

- (void)createSucceeded
{
	GMRAlertView * alert = [[GMRAlertView alloc] initWithStyle:GMRAlertViewStyleNotification 
														 title:@"Success" 
													   message:@"Account Created Successfully!\nPlease check your email to activate your new acocunt."
													  callback:^(GMRAlertView * alertView){
														  [alertView release];
														  [self transitionOut];
													  }];
	[alert show];

}

- (void)transitionOut
{
	[self.inputController viewWillAppear:YES];
	[self.navigationController popViewControllerAnimated:YES];
	
	/*[self viewWillDisappear:YES];
	[inputController viewWillAppear:YES];
	[UIView transitionWithView:self.view.superview
					  duration:0.35f 
					   options:UIViewAnimationOptionCurveEaseInOut  
					animations:^{
						self.view.superview.transform = CGAffineTransformIdentity;
					} 
					completion:^(BOOL finished){
						self.view.superview.frame = CGRectMake(self.view.superview.frame.origin.x, 0.0, self.view.superview.frame.size.width/2, self.view.superview.frame.size.height); 
						[self viewDidDisappear:YES];
						[inputController viewDidAppear:YES];
					}];
	 */
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
    self.email           = nil;
	self.username        = nil; 
	self.password        = nil; 
	self.passwordConfirm = nil;
}


- (void)dealloc {
	
    [super dealloc];
}


@end
