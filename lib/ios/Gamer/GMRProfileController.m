//
//  GMRProfileController.m
//  Gamer
//
//  Created by Adam Venturella on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "GMRProfileController.h"
#import "GMRProfileController+AliasTable.h"
#import "GMRProfileController+MailViewMods.h"
#import "MFMailComposeViewController+GMRComposeViewStyle.h"
#import "GMRMainController.h"
#import "GMRLabel.h"
#import "UIButton+GMRButtonTypes.h"
#import "GMRAlertView.h"
#import "GMRNoneView.h"
#import "GMRCreateAliasController.h"


@implementation GMRProfileController
@synthesize navigationBar, aliasTableView, aliases;

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



- (void)viewDidLoad 
{
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Profile"];
	[self.navigationItem setHidesBackButton:YES];
	
	UIButton * addAliasButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeAdd];
	[addAliasButton addTarget:self action:@selector(addAlias) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * addAlias = [[UIBarButtonItem alloc] initWithCustomView:addAliasButton];
	
	[self.navigationItem setRightBarButtonItem:addAlias animated:YES];
	[addAlias release];
	
	
	[self.navigationBar setItems:[NSArray arrayWithObject:self.navigationItem]];
	
	UIImageView * navigationBarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBarBackgroundShadow.png"]];
	navigationBarShadow.frame         = CGRectMake(0, 44, 320.0, 9.0);

	[self.view addSubview:navigationBarShadow];
	[navigationBarShadow release];
	
	[self aliasTableRefresh];
	
	[self addObserver:self 
		   forKeyPath:@"aliases" 
			  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
			  context:nil];
	
	[super viewDidLoad];
}

- (void)noAliases
{
	if(!noAliasesView)
	{
		noAliasesView = [[GMRNoneView alloc] initWithLabel:@"No Registered Aliases."];
		noAliasesView.frame = (CGRect){ {0.0, 106.0 }, noAliasesView.frame.size };
		[self.view addSubview:noAliasesView];
		[noAliasesView release];
	}
}


- (void)addAlias
{
	if(!aliases)
	{
		aliases = [[NSMutableArray array] retain];
		
	}
	
	GMRCreateAliasController * controller   = [[GMRCreateAliasController alloc] initWithProfileController:self];
	UINavigationController * createAlias    = [[UINavigationController alloc] initWithRootViewController:controller];
	
	UIImageView * navigationBarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBarBackgroundShadow.png"]];
	navigationBarShadow.frame         = CGRectMake(0, 64, 320.0, 9.0);
	
	[createAlias.view addSubview:navigationBarShadow];
	[navigationBarShadow release];
	
	
	[self presentModalViewController:createAlias 
							animated:YES];
	[createAlias release];
	[controller  release];
}

- (IBAction) performAction:(id)sender
{
	NSUInteger tag = [sender tag];
	
	switch(tag)
	{
		case 0: // someone took my alias
			[self aliasDispute];
			break;
			
		case 1: // request a game
			[self requestGameOrFeature];
			break;
			
		case 2: // logout
			[self logout];
			break;
			
	}
	
}

- (void)aliasDispute
{
	[self sendMail:@"Someone took my alias!" 
		   message:@"Alias: ?\nPlatform: ?\n"
			 to:@"help@gamepopapp.com"];
}

- (void)requestGameOrFeature
{
	[self sendMail:@"Request" 
		   message:@"I would like to request a..."
			 to:@"features@gamepopapp.com"];
	
}


- (void)logout
{
	GMRAlertView * alert = [[GMRAlertView alloc] initWithStyle:GMRAlertViewStyleConfirmation 
														 title:@"Logout?" 
													   message:@"Are you sure you wish to logout?" 
													  delegate:self];
	[alert show];
	
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
		[self presentModalViewController:mailViewController animated:YES];
		
		/*MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
		mailViewController.mailComposeDelegate = self;
		
		// Optional Configuration Parameters to make life easier for the user
		[mailViewController setSubject:messageTitle];
		[mailViewController setMessageBody:messageBody isHTML:NO];
		[mailViewController setToRecipients:[NSArray arrayWithObject:email]];
		
		
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
		[mailViewController release];*/
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	
	
	NSKeyValueChange kind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
	NSIndexSet * indexes  = [change objectForKey:NSKeyValueChangeIndexesKey];
	
	[aliasTableView beginUpdates];
	
	switch(kind)
	{
		case NSKeyValueChangeInsertion:
			[aliasTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[indexes firstIndex] inSection:0]] 
								withRowAnimation:UITableViewRowAnimationNone];
			break;
			
		case NSKeyValueChangeRemoval:
			[aliasTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[indexes firstIndex] inSection:0]]  
								withRowAnimation:UITableViewRowAnimationNone];
			break;		
	}
	
	[aliasTableView endUpdates];
	
	
	NSUInteger remaining = [aliasTableView numberOfRowsInSection:0];
	
	if(remaining == 0)
	{
		[self noAliases];
	}
	else if(noAliasesView && remaining > 0)
	{
		[noAliasesView removeFromSuperview];
		noAliasesView = nil;
	}
	
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)alertViewDidDismiss:(GMRAlertView *)alertView
{
	if(alertView.selectedButtonIndex == 1)
	{
		// Perform the actual logout
		//NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
		//[defaults removeObjectForKey:@"token"];
		//[defaults removeObjectForKey:@"username"];
		
		// Relfect the logout state
		UITabBarController * tabBarController = (UITabBarController *)self.parentViewController;
		GMRMainController * mainController = (GMRMainController *)tabBarController.delegate;
		[mainController logout];
	}
	
	[alertView release];
}

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
	NSLog(@"Profile Controller... Out!");
	self.navigationBar = nil;
	self.aliasTableView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[self removeObserver:self 
			  forKeyPath:@"aliases"];
	
	self.navigationBar = nil;
	self.aliasTableView = nil;
	self.aliases = nil;
	
    [super dealloc];
}


@end
