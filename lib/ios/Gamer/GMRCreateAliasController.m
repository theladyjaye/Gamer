//
//  GMRCreateAliasController.m
//  Gamer
//
//  Created by Adam Venturella on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <dispatch/dispatch.h>
#import <QuartzCore/QuartzCore.h>
#import "GMRCreateAliasController.h"
#import "UIButton+GMRButtonTypes.h"
#import "GMRLabel.h"
#import "GMRAlias.h"
#import "GMRCreateAliasGlobals.h"
#import "GMRProfileController.h"
#import "GMRCreateAliasController+Navigation.h"
#import "GMRMenuButton.h"

#import "GMRForm.h"
#import "GMRNotNilValidator.h"
#import "GMRPlatformValidator.h"
#import "GMRPredicateValidator.h"
#import "GMRInputValidator.h"
#import "GMRClient.h"
#import "GMRGlobals.h"
#import "GMRAliasListCell.h"
#import "GMRAlertView.h"

GMRAlias * kCreateAliasProgress;

@implementation GMRCreateAliasController
@synthesize platform, alias, howItWorksView;

- (id)initWithProfileController:(GMRProfileController *)controller
{
	
	self = [super initWithNibName:nil bundle:nil];
	
	if(self)
	{
		// assignment only
		profileController = controller;
		
	}
	
	return self;
}


- (void)viewDidLoad 
{
    UIButton * cancelButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeCancel];
	[cancelButton addTarget:self action:@selector(dismissModalViewController) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton * saveButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeSave];
	[saveButton addTarget:self action:@selector(saveAlias) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	UIBarButtonItem * save   = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
	
	
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Link Alias"];
	self.navigationItem.leftBarButtonItem  = cancel;
	self.navigationItem.rightBarButtonItem = save;
	
	[cancel release];
	[save release];
	
	kCreateAliasProgress = [[GMRAlias alloc] init];
	
	[kCreateAliasProgress addObserver:self 
						   forKeyPath:@"platform" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	[kCreateAliasProgress addObserver:self 
						   forKeyPath:@"alias" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	
	// Add the rounded background to "How It Works"
	howItWorksView.transform = CGAffineTransformMakeTranslation(0.0, 100);
	
	CGFloat roundedColor = 246.0/255.0;
	UIView * roundedView = [[UIView alloc] initWithFrame:CGRectMake(4.0, 8.0, 312.0, 68.0)];
	
	
	roundedView.layer.cornerRadius    = 5.0;
	roundedView.layer.backgroundColor = [UIColor colorWithRed:roundedColor 
														green:roundedColor 
														 blue:roundedColor 
														alpha:1.0].CGColor;
	
	
	[howItWorksView insertSubview:roundedView atIndex:0];
	[roundedView release];
}

- (void)viewDidAppear:(BOOL)animated
{
	howItWorksView.hidden = NO;
	[UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 howItWorksView.transform = CGAffineTransformIdentity;
					 } 
					 completion:NULL];
}

- (void)saveAlias
{
	GMRForm * form = [[GMRForm alloc] initWithContext:kCreateAliasProgress];
	
	[form addValidator:[GMRPlatformValidator validatorWithKeyPath:@"platform" 
												      requirement:GMRValidatorRequirementRequired 
													      message:@"Invalid Platform"]];
	
	[form addValidator:[GMRInputValidator validatorWithKeyPath:@"alias"
												   requirement:GMRValidatorRequirementRequired 
													 minLength:3
													 maxLength:0
													   message:@"Invalid Alias"]];
	
	if(form.ok)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[kGamerApi registerAlias:kCreateAliasProgress.alias 
						platform:kCreateAliasProgress.platform 
					withCallback:^(BOOL ok, NSDictionary * response)
					 {
						 if(ok)
						 {
							 dispatch_async(dispatch_get_main_queue(), ^{
								 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
								 
								 NSUInteger insertIndex = -1;
								 
								 for(GMRAlias * object in profileController.aliases)
								 {
									 if(kCreateAliasProgress.platform > object.platform)
									 {
										 insertIndex = [profileController.aliases indexOfObject:object];
									 }
									 else if(kCreateAliasProgress.platform == object.platform)
									 {
										 // someone just changed their alias for an existing platform
										 object.alias = kCreateAliasProgress.alias;
										 
										 insertIndex = [profileController.aliases indexOfObject:object];
										 
										 UITableView * aliasTableView = profileController.aliasTableView;
										 GMRAliasListCell *cell = (GMRAliasListCell *)[aliasTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:insertIndex 
																																			   inSection:0]];
										 if(cell != nil)
										 {
											 cell.alias = object.alias;
											 [cell setNeedsDisplay];
										 }
										 
										 [self dismissModalViewController];
										 return;
									 }
									 
								 }
								 
								 insertIndex = insertIndex == -1 ? 0 : insertIndex + 1;
								 
								 // might need to add some more information for editing.
								 /*NSString * matchId = [response objectForKey:@"match"];
								 
								 // prime some values:
								 kCreateMatchProgress.id = matchId;
								 kCreateMatchProgress.created_by = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
								 */
								 
								 
								 [profileController willChange:NSKeyValueChangeInsertion 
											   valuesAtIndexes:[NSIndexSet indexSetWithIndex:insertIndex] 
														forKey:@"aliases"];
								 
								 [profileController.aliases insertObject:kCreateAliasProgress 
																 atIndex:insertIndex];
								 
								 
								 [profileController didChange:NSKeyValueChangeInsertion 
											  valuesAtIndexes:[NSIndexSet indexSetWithIndex:insertIndex] 
													   forKey:@"aliases"];
								 
								 [self dismissModalViewController];
								 
							 }); 
						 }
						 else 
						 {
							 dispatch_async(dispatch_get_main_queue(), ^{
								 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
								 
								 GMRAlertView * alert = [[GMRAlertView alloc] initWithStyle:GMRAlertViewStyleNotification 
																					  title:@"Unable to link alias" 
																					message:[NSString stringWithFormat:@"The alias \"%@\" has already been linked to an account on %@.", kCreateAliasProgress.alias, [GMRClient formalDisplayNameForPlatform:kCreateAliasProgress.platform]] 
																				   callback:^(GMRAlertView *alertView) {
																					   [alertView release];
																				   }];
								 [alert show];
							 });
							 
						 }
						 
					 }];
	}
	else 
	{
		//NSLog(@"Form Errors: %@", form.errors);
		NSString * errors  = [form.errors componentsJoinedByString:@"\n"];
		GMRAlertView * alert = [[GMRAlertView alloc] initWithStyle:GMRAlertViewStyleNotification 
															 title:@"Unable to link alias" 
														   message:errors
														  callback:^(GMRAlertView * alertView){
															  [alertView release];
														  }];
		
		[alert show];
	}
}

- (void)dismissModalViewController
{
	[profileController dismissModalViewControllerAnimated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if([[change objectForKey:NSKeyValueChangeKindKey] intValue] == NSKeyValueChangeSetting)
	{
		if([keyPath isEqualToString:@"platform"])
		{
			if([[change objectForKey:NSKeyValueChangeNewKey] intValue] != [[change objectForKey:NSKeyValueChangeOldKey] intValue])
			{
				NSString * displayString = [GMRClient formalDisplayNameForPlatform:kCreateAliasProgress.platform];
				
				if(self.platform.selected == NO)
				{
					self.platform.selected  = YES;
				}
				
				self.platform.label.text = displayString;
			}
		}
		else if([keyPath isEqualToString:@"alias"])
		{
			if([kCreateAliasProgress.alias length] >= 3)
			{
				self.alias.selected = YES;
				self.alias.label.text = kCreateAliasProgress.alias;
			}
			else 
			{
				if(kCreateAliasProgress.alias)
				{
					self.alias.label.text = @"Alias";
					self.alias.selected = NO;
					
					kCreateAliasProgress.alias = nil;
				}
			}
		}	
	}
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

- (void)viewDidUnload 
{
    [super viewDidUnload];
	self.platform = nil;
	self.alias = nil;
	self.howItWorksView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    self.platform = nil;
	self.alias = nil;
	self.howItWorksView = nil;
	
	[kCreateAliasProgress removeObserver:self 
							  forKeyPath:@"platform"];
	
	[kCreateAliasProgress removeObserver:self 
							  forKeyPath:@"alias"];
	
	[kCreateAliasProgress release];
	kCreateAliasProgress = nil;
	
	[super dealloc];
}


@end
