//
//  GMRCreateAliasController.m
//  Gamer
//
//  Created by Adam Venturella on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <dispatch/dispatch.h>
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

GMRAlias * kCreateAliasProgress;

@implementation GMRCreateAliasController
@synthesize platform, alias;

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
	
	
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Create Alias"];
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
								 
								 /*NSUInteger insertIndex = -1;
								 
								 for(GMRAlias * alias in self.platformController.aliases)
								 {
									 if([kCreateMatchProgress.scheduled_time compare:match.scheduled_time] == NSOrderedDescending)
									 {
										 insertIndex = [matchesDataSourceController.matches indexOfObject:match];
									 }
									 
								 }
								 
								 insertIndex = insertIndex == -1 ? 0 : insertIndex + 1;
								 NSString * matchId = [response objectForKey:@"match"];
								 
								 // prime some values:
								 kCreateMatchProgress.id = matchId;
								 kCreateMatchProgress.created_by = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
								 
								 
								 [matchesDataSourceController willChange:NSKeyValueChangeInsertion 
														 valuesAtIndexes:[NSIndexSet indexSetWithIndex:insertIndex] 
																  forKey:@"matches"];
								 
								 [kScheduledMatches insertObject:kCreateMatchProgress 
														 atIndex:insertIndex];
								 
								 
								 [matchesDataSourceController didChange:NSKeyValueChangeInsertion 
														valuesAtIndexes:[NSIndexSet indexSetWithIndex:insertIndex] 
																 forKey:@"matches"]*/
								 
								 [self dismissModalViewController];
								 
							 }); 
						 }
						 else 
						 {
							 dispatch_async(dispatch_get_main_queue(), ^{
								 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
							 });
							 
						 }
						 
						 NSLog(@"%@", response);
					 }];
	}
	else 
	{
		NSLog(@"%@", form.errors);
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
				NSString * displayString;
				
				switch (kCreateAliasProgress.platform) 
				{
					case GMRPlatformBattleNet:
						displayString = @"BattleNet";
						break;
						
					case GMRPlatformPlaystation2:
						displayString = @"Playstation 2";
						break;
						
					case GMRPlatformPlaystation3:
						displayString = @"Playstation 3";
						break;
						
					case GMRPlatformSteam:
						displayString = @"Steam";
						break;
						
					case GMRPlatformWii:
						displayString = @"Wii";
						break;
						
					case GMRPlatformXBox360:
						displayString = @"Xbox 360";
						break;
				}
				
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    self.platform = nil;
	self.alias = nil;
	
	[kCreateAliasProgress removeObserver:self 
							  forKeyPath:@"platform"];
	
	[kCreateAliasProgress removeObserver:self 
							  forKeyPath:@"alias"];
	
	[kCreateAliasProgress release];
	kCreateAliasProgress = nil;
	
	[super dealloc];
}


@end
