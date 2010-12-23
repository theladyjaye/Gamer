//
//  GMRProfileController+MailViewMods.m
//  Gamer
//
//  Created by Adam Venturella on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRProfileController+MailViewMods.h"
#import "GMRLabel.h"
#import "UIButton+GMRButtonTypes.h"

static UINavigationItem * composeViewNavigationItem;

@implementation GMRProfileController(MailViewMods)
/*
-(void)modfiyMailComposeViewNavigationBar:(UINavigationBar *)sourceBar newBar:(UINavigationBar *)newBar title:(NSString *)barTitle
{
	composeViewNavigationItem = sourceBar.topItem;
	
	UINavigationItem * styledItem = [[UINavigationItem alloc] init];
	styledItem.titleView = [GMRLabel titleLabelWithString:barTitle];
	
	// Proxy the Buttons
	// I tried passing through the sourceBar.topItem.leftBarButtonItem/rightBarButtonItem target and action
	// into the 2 new buttons below.  Cancel Worked, but Send Failed.  Like it's checking for the sender or something
	// anyway, for the sake of consistencey, I am going to handle both buttons the same. 
	// If we tell the send button, to invoke the selector with itself, send worked, so we are going to do it that 
	// way for both.
	
	
	// CANCEL
	UIButton * cancelButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeCancel];
	// the line below worked, but again, doing the same technique for send failed. Lets keep em consistent
	//[cancelButton addTarget:topItem.leftBarButtonItem.target action:topItem.leftBarButtonItem.action forControlEvents:UIControlEventTouchUpInside];
	[cancelButton addTarget:self action:@selector(cancelProxy) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	
	
	// SEND
	UIButton * sendButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeSend];
	// this fails, I think it's checking for composeViewNavigationItem.rightBarButtonItem as the sender argument
	//[sendButton addTarget:topItem.rightBarButtonItem.target action:topItem.rightBarButtonItem.action forControlEvents:UIControlEventTouchUpInside];
	[sendButton addTarget:self action:@selector(sendProxy) forControlEvents:UIControlEventTouchUpInside];
	
	
	UIBarButtonItem * send = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
	
	styledItem.leftBarButtonItem  = cancel;
	styledItem.rightBarButtonItem = send;
	
	[newBar setItems:[NSArray arrayWithObject:styledItem] animated:NO];
	
	[styledItem release];
	[cancel release];
	[send release];
}

- (void)sendProxy
{
	UIBarButtonItem * target = composeViewNavigationItem.rightBarButtonItem;
	[target.target performSelector:target.action withObject:target];
	
}

- (void)cancelProxy
{
	UIBarButtonItem * target = composeViewNavigationItem.leftBarButtonItem;
	[target.target performSelector:target.action withObject:target];
	
}
 */
@end
