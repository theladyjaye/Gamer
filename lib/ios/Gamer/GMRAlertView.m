//
//  GMRAlertView.m
//  Gamer
//
//  Created by Adam Venturella on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRAlertView.h"

@interface GMRAlertView(Private)
- (void)showConfirmation;
- (void)showNotification;
@end


@implementation GMRAlertView
@synthesize alertTitle, alertMessage, style, selectedButtonIndex;

- (id)initWithStyle:(GMRAlertViewStyle)alertStyle title:(NSString *)title message:(id)message callback:(void (^)(GMRAlertView *))block
{
	self = [super init];
	
	if(self)
	{
		style             = alertStyle;
		self.alertTitle   = title;
		self.alertMessage = message;
		
		if(block)
			callback          = [block copy];
	}
	
	return self;
}

- (id)initWithStyle:(GMRAlertViewStyle)alertStyle title:(NSString *)title message:(id)message delegate:(id<NSObject>)del
{
	self = [super init];
	
	if(self)
	{
		style             = alertStyle;
		self.alertTitle   = title;
		self.alertMessage = message;
		delegate = del;
	}
	
	return self;
}
- (id)initWithTitle:(NSString *)title message:(id)message delegate:(id<NSObject>)del;
{
	//self = [super initWithNibName:nil bundle:nil];
	self = [super init];
	
	if(self)
	{
		style = GMRAlertViewStyleNotification;
		self.alertTitle   = title;
		self.alertMessage = message;
		delegate = del;
	}
	
	return self;
}

- (void)show
{
	switch(self.style)
	{
		case GMRAlertViewStyleConfirmation:
			[self showConfirmation];
			break;
		
		case GMRAlertViewStyleNotification:
			[self showNotification];
			break;
	}
}

- (void)showConfirmation
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:self.alertTitle 
													 message:(NSString * )self.alertMessage 
													delegate:self 
										   cancelButtonTitle:@"Cancel" 
										   otherButtonTitles:@"Ok",nil];
	[alert show];
}

- (void)showNotification
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:self.alertTitle 
													 message:(NSString * )self.alertMessage 
													delegate:self 
										   cancelButtonTitle:@"Dismiss" 
										   otherButtonTitles:nil];
	[alert show];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	
	[alertView release];
	
	selectedButtonIndex = buttonIndex;
	
	if(callback)
	{
		callback(self);
		return;
	}
	
	if(delegate && [delegate respondsToSelector:@selector(alertViewDidDismiss:)])
		[delegate performSelector:@selector(alertViewDidDismiss:) withObject:self];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    self.alertTitle   = nil;
	self.alertMessage = nil;
	[callback release];
	callback = nil;
	[super dealloc];
}


@end
