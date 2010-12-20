//
//  MFMailComposeViewController+GMRStyle.m
//  Gamer
//
//  Created by Adam Venturella on 12/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MFMailComposeViewController+GMRComposeViewStyle.h"
#import "UIButton+GMRButtonTypes.h"
#import "GMRLabel.h"

@interface GMRComposeViewProxy : NSObject
{
	UINavigationItem * composeViewNavigationItem;
}
@property (nonatomic, retain) UINavigationItem * composeViewNavigationItem;
- (void)cancelProxy;
- (void)sendProxy;
@end

@implementation GMRComposeViewProxy
@synthesize composeViewNavigationItem;

- (void)sendProxy
{
	UIBarButtonItem * target = self.composeViewNavigationItem.rightBarButtonItem;
	[target.target performSelector:target.action withObject:target];
	[self release];
	
}

- (void)cancelProxy
{
	UIBarButtonItem * target = self.composeViewNavigationItem.leftBarButtonItem;
	[target.target performSelector:target.action withObject:target];
	[self release];
	
}

- (void)dealloc
{
	self.composeViewNavigationItem = nil;
	[super dealloc];
}

@end



void modfiyMailComposeViewNavigationBar(UINavigationBar * sourceBar, UINavigationBar * newBar, NSString* barTitle)
{
	GMRComposeViewProxy * proxy = [[GMRComposeViewProxy alloc] init];
	proxy.composeViewNavigationItem = sourceBar.topItem;
	
	
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
	[cancelButton addTarget:proxy action:@selector(cancelProxy) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	
	
	// SEND
	UIButton * sendButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeSend];
	// this fails, I think it's checking for composeViewNavigationItem.rightBarButtonItem as the sender argument
	//[sendButton addTarget:topItem.rightBarButtonItem.target action:topItem.rightBarButtonItem.action forControlEvents:UIControlEventTouchUpInside];
	[sendButton addTarget:proxy action:@selector(sendProxy) forControlEvents:UIControlEventTouchUpInside];
	
	
	UIBarButtonItem * send = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
	
	styledItem.leftBarButtonItem  = cancel;
	styledItem.rightBarButtonItem = send;
	
	[newBar setItems:[NSArray arrayWithObject:styledItem] animated:NO];
	
	[styledItem release];
	[cancel release];
	[send release];
}

@implementation MFMailComposeViewController(GMRComposeViewStyle)

+(MFMailComposeViewController *)composeViewWithTitle:(NSString *)messageTitle body:(NSString *)messageBody recipients:(NSArray *)addresses
{
	MFMailComposeViewController * mailViewController = [[MFMailComposeViewController alloc] init];
	
	[mailViewController setSubject:messageTitle];
	[mailViewController setMessageBody:messageBody isHTML:NO];
	
	if(addresses)
		[mailViewController setToRecipients:addresses];
	
	// Need to replace the bar with our own Style
	
	UINavigationBar * styledBar = [[UINavigationBar alloc] initWithFrame:mailViewController.navigationBar.frame];
	
	UIImageView * navigationBarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBarBackgroundShadow.png"]];
	navigationBarShadow.frame         = CGRectMake(0, 64, 320.0, 9.0);
	
	
	
	// we don't want to use an index, as Apple could change 
	// that layout order sometime in the future.
	// so we search for it.
	for (id v in mailViewController.view.subviews) 
	{
		if([v class] == [UINavigationBar class])
		{
			modfiyMailComposeViewNavigationBar(v, styledBar, messageTitle);
			break;
		}
	}
	
	[mailViewController.view addSubview:navigationBarShadow];
	[mailViewController.view addSubview:styledBar];
	
	
	[styledBar release];
	[navigationBarShadow release];
	
	return [mailViewController autorelease];
}
@end
