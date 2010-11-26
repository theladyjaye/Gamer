//
//  GMRCreateGameController.m
//  Gamer
//
//  Created by Adam Venturella on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRCreateGameController.h"
#import "GMRMatch.h"
#import "GMRGame.h"
#import "GMRCreateGameGlobals.h"
#import "GMRMenuButton.h"
#import "GMRMenuButtonAltLabel.h"

#import "NSDate+JSON.h"


GMRMatch * kCreateMatchProgress = nil;

@implementation GMRCreateGameController
@synthesize platform, gameAndMode,availability,players,time,description;

- (void)viewDidLoad 
{
	UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
																style:UIBarButtonItemStylePlain 
															   target:self 
															   action:@selector(dismissModalViewController)];

	UIBarButtonItem * save  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																			target:self 
																			action:@selector(saveMatch)];
	
	
	self.navigationItem.title = @"Create Game";
	self.navigationItem.leftBarButtonItem = cancel;
	
	
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
						   forKeyPath:@"players" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"time" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"description" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	
	[super viewDidLoad];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	static enum{
		Invalid           = 0,
		ValidPlatform     = 1 << 0,
		ValidGameTitle    = 1 << 1,
		ValidGameId       = 1 << 2,
		ValidGameMode     = 1 << 3,
		ValidAvailability = 1 << 4,
		ValidPlayers      = 1 << 5,
		ValidTime         = 1 << 6,
	};
	static int formProgress = Invalid;
	
	//NSLog(@"%@ : %i - %i", [change objectForKey:NSKeyValueChangeKindKey], [[change objectForKey:NSKeyValueChangeKindKey] intValue], NSKeyValueChangeSetting);
	
	if([[change objectForKey:NSKeyValueChangeKindKey] intValue] == NSKeyValueChangeSetting)
	{
		if([keyPath isEqualToString:@"platform"])
		{
			if([[change objectForKey:NSKeyValueChangeNewKey] intValue] != [[change objectForKey:NSKeyValueChangeOldKey] intValue])
			{
				NSString * displayString;
				
				switch (kCreateMatchProgress.platform) 
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
					formProgress = formProgress | ValidPlatform;
					self.platform.selected  = YES;
				}
				
				self.platform.label.text = displayString;
				
				if(kCreateMatchProgress.game)
					kCreateMatchProgress.game = nil;
				
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
					kCreateMatchProgress.players = 0;
				}
				else 
				{
					if(self.gameAndMode.selected == NO)
					{
						formProgress = formProgress | ValidGameTitle;
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
				formProgress = formProgress | ValidGameMode;
				self.gameAndMode.altLabel.text = [kCreateMatchProgress.game.modes objectAtIndex:kCreateMatchProgress.game.selectedMode];
			}
		}
		else if([keyPath isEqualToString:@"availability"])
		{
			if(![[change objectForKey:NSKeyValueChangeNewKey] isEqualToString:[change objectForKey:NSKeyValueChangeOldKey]])
			{
				formProgress = formProgress | ValidAvailability;
				self.availability.selected   = YES;
				self.availability.label.text = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToString:@"public"] ? @"Public" : @"Private";
			}	
		}
		else if([keyPath isEqualToString:@"players"])
		{
			if([[change objectForKey:NSKeyValueChangeNewKey] intValue] != [[change objectForKey:NSKeyValueChangeOldKey] intValue])
			{
				formProgress = formProgress | ValidPlayers;
				self.players.selected   = YES;
				self.players.label.text = [NSString stringWithFormat:@"%i Players", kCreateMatchProgress.players];
			}
		}
		else if([keyPath isEqualToString:@"time"])
		{
			formProgress = formProgress | ValidTime;
			self.time.label.text = [NSDate gamerScheduleTimeString:kCreateMatchProgress.time];
			self.time.selected = YES;
		}
		else if([keyPath isEqualToString:@"description"])
		{
			self.description.selected = YES;
			self.description.label.text = kCreateMatchProgress.description;
		}
	}
	

	//NSLog(@"%@", change);
}

- (void)dismissModalViewController
{
	[self dismissModalViewControllerAnimated:YES];
}


- (void)saveMatch
{
	NSLog(@"Saving!");
	[self dismissModalViewController];
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.platform     = nil;
	self.gameAndMode = nil;
	self.availability = nil;
	self.players = nil;
	self.time = nil;
	self.description = nil;
}


- (void)dealloc 
{
	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"platform"];

	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"game"];
	
	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"game.selectedMode"];
	
	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"availability"];
	
	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"players"];
	
	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"time"];
	
	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"description"];

	
	[kCreateMatchProgress release];
	[super dealloc];
}


@end
