//
//  GMRCreateGameController.m
//  Gamer
//
//  Created by Adam Venturella on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <dispatch/dispatch.h>
#import "GMRCreateGameController.h"
#import "GMRMatch.h"
#import "GMRGame.h"
#import "GMRCreateGameGlobals.h"
#import "GMRMenuButton.h"
#import "GMRMenuButtonAltLabel.h"

#import "NSDate+JSON.h"

#import "GMRForm.h"
#import "GMRNotNilValidator.h"
#import "GMRPlatformValidator.h"
#import "GMRPredicateValidator.h"
#import "GMRInputValidator.h"
#import "GMRLabel.h"
#import "UIButton+GMRButtonTypes.h"

#import "GMRGlobals.h"
#import "GMRClient.h"
#import "OverviewController.h"

GMRMatch * kCreateMatchProgress = nil;

@implementation GMRCreateGameController
@synthesize platform, gameAndMode, availability, players, time, description, matchesDataSourceController;

- (void)viewDidLoad 
{
	UIButton * cancelButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeCancel];
	[cancelButton addTarget:self action:@selector(dismissModalViewController) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton * saveButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeSave];
	[saveButton addTarget:self action:@selector(saveMatch) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	UIBarButtonItem * save   = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
	
	
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Create Game"];
	self.navigationItem.leftBarButtonItem  = cancel;
	self.navigationItem.rightBarButtonItem = save;
	
	[cancel release];
	[save release];
	
	
	kCreateMatchProgress = [[GMRMatch alloc] init];
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"platform" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"game" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"game.selectedMode" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"availability" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"maxPlayers" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"scheduled_time" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"label" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	
	[super viewDidLoad];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	
	//NSLog(@"%@ : %i - %i", [change objectForKey:NSKeyValueChangeKindKey], [[change objectForKey:NSKeyValueChangeKindKey] intValue], NSKeyValueChangeSetting);
	
	if([[change objectForKey:NSKeyValueChangeKindKey] intValue] == NSKeyValueChangeSetting)
	{
		if([keyPath isEqualToString:@"platform"])
		{
			if([[change objectForKey:NSKeyValueChangeNewKey] intValue] != [[change objectForKey:NSKeyValueChangeOldKey] intValue])
			{
				NSString * displayString = [GMRClient formalDisplayNameForPlatform:kCreateMatchProgress.platform];
				
				if(self.platform.selected == NO)
				{
					self.platform.selected  = YES;
				}
				
				self.platform.label.text = displayString;
				
				if(kCreateMatchProgress.game)
				{
					kCreateMatchProgress.game = nil;
				}
				
			}
		}
		
		else if([keyPath isEqualToString:@"game"])
		{
			if([change objectForKey:NSKeyValueChangeNewKey] != [change objectForKey:NSKeyValueChangeOldKey])
			{
				if ([change objectForKey:NSKeyValueChangeNewKey] == [NSNull null])
				{
					self.gameAndMode.selected      = NO;
					self.gameAndMode.label.text    = @"Game";
					self.gameAndMode.altLabel.text = @"Mode";
					
					self.players.selected   = NO;
					self.players.label.text = @"Players";
					
					kCreateMatchProgress.maxPlayers = 0;
				}
				else 
				{
					if(self.gameAndMode.selected == NO)
					{
						self.gameAndMode.selected   = YES;
						self.gameAndMode.label.text = kCreateMatchProgress.game.label;
					}
				}
			}
		}
		else if([keyPath isEqualToString:@"game.selectedMode"])
		{
			if(kCreateMatchProgress.game.selectedMode > -1)
			{
				self.gameAndMode.altLabel.text = [kCreateMatchProgress.game.modes objectAtIndex:kCreateMatchProgress.game.selectedMode];
			}
		}
		else if([keyPath isEqualToString:@"availability"])
		{
			if([[change objectForKey:NSKeyValueChangeNewKey] intValue] != [[change objectForKey:NSKeyValueChangeOldKey] intValue])
			{
				self.availability.selected   = YES;
				self.availability.label.text = [[change objectForKey:NSKeyValueChangeNewKey] intValue] == GMRMatchAvailabliltyPublic ? @"Public" : @"Private";
			}	
		}
		else if([keyPath isEqualToString:@"maxPlayers"])
		{
			if([[change objectForKey:NSKeyValueChangeNewKey] intValue] != [[change objectForKey:NSKeyValueChangeOldKey] intValue])
			{
				self.players.selected   = YES;
				self.players.label.text = [NSString stringWithFormat:@"%i Players", kCreateMatchProgress.maxPlayers];
			}
		}
		else if([keyPath isEqualToString:@"scheduled_time"])
		{
			self.time.label.text = [NSDate gamerScheduleTimeString:kCreateMatchProgress.scheduled_time];
			self.time.selected = YES;
		}
		else if([keyPath isEqualToString:@"label"])
		{
			if([kCreateMatchProgress.label length] >= 4)
			{
				self.description.selected = YES;
				self.description.label.text = kCreateMatchProgress.label;
			}
			else 
			{
				if(kCreateMatchProgress.label)
				{
					self.description.label.text = @"Description";
					self.description.selected = NO;
				
					kCreateMatchProgress.label = nil;
				}
			}

			
		}
	}
}

- (void)saveMatch
{
	GMRForm * form = [[GMRForm alloc] initWithContext:kCreateMatchProgress];
	
	[form addValidator:[GMRPlatformValidator validatorWithKeyPath:@"platform" 
												      requirement:GMRValidatorRequirementRequired 
													      message:@"Invalid Platform"]];

	[form addValidator:[GMRNotNilValidator validatorWithKeyPath:@"game" 
												    requirement:GMRValidatorRequirementRequired 
													    message:@"Invalid Game"]];
	
	
	[form addValidator:[GMRPredicateValidator validatorWithPredicate:[NSPredicate predicateWithFormat:@"game.selectedMode > -1"]
												         requirement:GMRValidatorRequirementRequired 
												  	         message:@"Invalid Game Mode"]];
	
	[form addValidator:[GMRPredicateValidator validatorWithPredicate:[NSPredicate predicateWithFormat:@"maxPlayers > 0 AND maxPlayers <= game.maxPlayers"]
												         requirement:GMRValidatorRequirementRequired 
												  	         message:@"Invalid Players"]];
	
	[form addValidator:[GMRPredicateValidator validatorWithPredicate:[NSPredicate predicateWithFormat:@"availability == %i OR availability == %i", GMRMatchAvailabliltyPublic, GMRMatchAvailabliltyPrivate]
												         requirement:GMRValidatorRequirementRequired 
												  	         message:@"Invalid Availability"]];
	
	[form addValidator:[GMRNotNilValidator validatorWithKeyPath:@"scheduled_time" 
												    requirement:GMRValidatorRequirementRequired 
													    message:@"Invalid Time"]];	
	
	[form addValidator:[GMRInputValidator validatorWithKeyPath:@"label"
												    requirement:GMRValidatorRequirementRequired 
													  minLength:4
													  maxLength:0
													    message:@"Invalid Description"]];	
	
	if(form.ok)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[kGamerApi matchCreate:kCreateMatchProgress.scheduled_time 
						gameId:[[kCreateMatchProgress.game.id componentsSeparatedByString:@"/"] objectAtIndex:1]
					  gameMode:[kCreateMatchProgress.game.modes objectAtIndex:kCreateMatchProgress.game.selectedMode]
					  platform:kCreateMatchProgress.platform 
				  availability:kCreateMatchProgress.availability 
					maxPlayers:kCreateMatchProgress.maxPlayers 
				invitedPlayers:nil 
						 label:kCreateMatchProgress.label
				  withCallback:^(BOOL ok, NSDictionary * response)
							  {
								  if(ok)
								  {
									  dispatch_async(dispatch_get_main_queue(), ^{
										  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
										  
										  NSUInteger insertIndex = -1;
										  
										  for(GMRMatch * match in matchesDataSourceController.matches)
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
													                      forKey:@"matches"];
										  
										  [self dismissModalViewController];
										  
									  }); 
								  }
								  else 
								  {
									  dispatch_async(dispatch_get_main_queue(), ^{
											[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
									  });
									  
								  }

								  //NSLog(@"%@", response);
							  }];
	}
	else 
	{
		NSLog(@"%@", form.errors);
	}

	/*if([self matchIsValid:kCreateMatchProgress])
	{
	
	}
	else 
	{
			
	}*/

	
	//[self dismissModalViewController];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)dismissModalViewController
{
	[self.matchesDataSourceController dismissModalViewControllerAnimated:YES];
	//[self.parentViewController dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

// this isn't running for some reason...
- (void)viewDidUnload {
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.platform     = nil;
	self.gameAndMode = nil;
	self.availability = nil;
	self.players = nil;
	self.time = nil;
	self.description = nil;
	
	[super viewDidUnload];
}


- (void)dealloc 
{
	[self.view removeFromSuperview];

	self.platform     = nil;
	self.gameAndMode = nil;
	self.availability = nil;
	self.players = nil;
	self.time = nil;
	self.description = nil;
	
	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"platform"];

	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"game"];
	
	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"game.selectedMode"];
	
	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"availability"];
	
	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"maxPlayers"];
	
	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"scheduled_time"];
	
	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"label"];

	
	[kCreateMatchProgress release];
	kCreateMatchProgress = nil;
	[super dealloc];
}


@end
