//
//  GMRGameDetailController+Sharing.m
//  Gamer
//
//  Created by Adam Venturella on 12/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRGameDetailController+Sharing.h"
#import "GMRAlertView.h"
#import "GMRLabel.h"
#import "UIButton+GMRButtonTypes.h"
#import "MFMailComposeViewController+GMRComposeViewStyle.h"
#import "GMRMatch.h"
#import "GMRGame.h"
#import "GMRUtils.h"
#import "GMRClient.h"
#import "NSDate+JSON.h"

static UINavigationItem * composeViewNavigationItem;

@implementation GMRGameDetailController(Sharing)

- (void)shareEmail
{
	//NSString * matchUrl = [NSString stringWithFormat:@"http://gamepopapp.com/%@/%@/%@", [GMRClient stringForPlatform:match.platform], [GMRUtils cleanupGameId:match.game.id], match.id];
	NSString * messageTitle = [NSString stringWithFormat:@"Playing %@", match.game.label];
	NSString * messageBody = [NSString stringWithFormat:@"%@\n%@\n@ %@\n(%@)\n\nYou in or out?\n\n%@", match.game.label, 
							  match.label, 
							  [NSDate gamerScheduleTimeString:match.scheduled_time], 
							  [NSDate relativeTime:match.scheduled_time], 
							  match.publicUrl];
	
	//NSLog(@"%@", match.publicUrl);
	[self sendMail:messageTitle 
		   message:messageBody 
				to:nil];
}

- (void)shareFacebook
{

}

- (void)shareTwitter
{

}

- (void)addToCalendar
{
	[match addToDefaultCalendar];
}

- (void)shareCopyUrl
{
	NSLog(@"%@", match.publicUrl);
	[UIPasteboard generalPasteboard].string = match.publicUrl;
}

- (void)sendMail:(NSString *)messageTitle message:(NSString *)messageBody to:(NSString *)email
{
	if([MFMailComposeViewController canSendMail])
	{
		NSArray * recipients = nil;
		
		if(email)
			recipients = [NSArray arrayWithObject:email];
		
		MFMailComposeViewController * mailViewController = [MFMailComposeViewController composeViewWithTitle:messageTitle 
																									    body:messageBody 
																								  recipients:recipients];
		mailViewController.mailComposeDelegate = self;
		
		
		// MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
		
		// Optional Configuration Parameters to make life easier for the user
		/*
		[mailViewController setSubject:messageTitle];
		[mailViewController setMessageBody:messageBody isHTML:NO];
		
		if(email)
			[mailViewController setToRecipients:[NSArray arrayWithObject:email]];
		 */
		
		
		// Need to replace the bar with our own Style
		/*
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
				[self modfiyMailComposeViewNavigationBar:v 
												  newBar:styledBar 
												   title:messageTitle];
				break;
			}
		}
		
		[mailViewController.view addSubview:navigationBarShadow];
		[mailViewController.view addSubview:styledBar];
		
		[self presentModalViewController:mailViewController animated:YES];
		
		[styledBar release];
		[navigationBarShadow release];
		 */
		//[mailViewController release];
		
		[self presentModalViewController:mailViewController animated:YES];
	}
	else 
	{
		[[[GMRAlertView alloc] initWithStyle:GMRAlertViewStyleNotification 
									   title:@"Oops..." 
									 message:@"It doesn't look like you are configured to send email." 
									callback:^(GMRAlertView * alert){
										[alert release];
									}] show];
	}
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissModalViewControllerAnimated:YES];
}

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
