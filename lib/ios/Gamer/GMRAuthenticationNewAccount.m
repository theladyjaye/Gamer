//
//  GMRAuthenticationNewAccount.m
//  Gamer
//
//  Created by Adam Venturella on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRAuthenticationNewAccount.h"
#import "GMRAuthenticationInputController.h"

@implementation GMRAuthenticationNewAccount
@synthesize inputController, email, username, password, passwordConfirm, form, topBar;
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)viewDidLoad
{
	//self.navigationBar.frame = CGRectMake(0, 20.0, self.view.frame.size.width, self.navigationBar.frame.size.height);
	self.topBar.transform = CGAffineTransformMakeTranslation(0.0, -60);
	[self.view insertSubview:form atIndex:0];
	[super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[UIView transitionWithView:self.topBar 
					  duration:0.35 
					   options:UIViewAnimationOptionCurveEaseOut 
					animations:^{
						self.topBar.transform = CGAffineTransformMakeTranslation(0.0, -60);
					} 
					completion:NULL];
}

- (void)viewWillAppear:(BOOL)animated
{
	[UIView transitionWithView:self.topBar 
					  duration:0.35 
					   options:UIViewAnimationOptionCurveEaseOut 
					animations:^{
						self.topBar.transform = CGAffineTransformIdentity;
					} 
					completion:NULL];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

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
							self.form.transform = CGAffineTransformMakeTranslation(0.0, -140.0);
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
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return YES;
	/*
	BOOL result = YES;
	
	if(range.length != 1 && ![string isEqualToString:@""])
	{
		if([textField isEqual:inputSerialNumber] || [textField isEqual:inputModelNumber])
		{
			SerialNumberFormatter * formatter = [[SerialNumberFormatter alloc] init];
			NSString * value  = [formatter stringForString:string];
			[formatter release];
			
			if(!value){
				result = NO;
			}
			
		}
	}
	
	return result;
	 */
}

- (IBAction)cancel:(id)sender
{
	[self transitionOut];
}

- (IBAction)create:(id)sender
{

}

- (void)transitionOut
{
	[self viewWillDisappear:YES];
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
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
    self.email = nil;
	self.username = nil; 
	self.password = nil; 
	self.passwordConfirm = nil;
	self.topBar = nil;
	self.form = nil;
}


- (void)dealloc {
	
    [super dealloc];
}


@end
