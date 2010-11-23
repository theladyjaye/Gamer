//
//  GMRCreateGameController.m
//  Gamer
//
//  Created by Adam Venturella on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRCreateGameController.h"
#import "GMRMatch.h"
#import "GMRCreateGameGlobals.h"
#import "GMRMenuButton.h"
#import "GMRMenuButtonAltLabel.h"
#import "GMRChoosePlatformController.h"
#import "GMRChooseGameAndMode.h"
#import "GMRChooseAvailability.h"
#import "GMRChoosePlayers.h"


GMRMatch * kCreateMatchProgress = nil;

@implementation GMRCreateGameController
@synthesize platform, gameAndMode,availability,players,time,description;

- (void)viewDidLoad 
{
	UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
																style:UIBarButtonItemStylePlain 
															   target:self 
															   action:@selector(dismissModalViewController)];
	self.navigationItem.title = @"Create Game";
	self.navigationItem.leftBarButtonItem = cancel;
	[cancel release];
	
	
	kCreateMatchProgress = [[GMRMatch alloc] init];
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"platform" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"gameTitle" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"gameMode" 
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
				
			}
		}
		else if([keyPath isEqualToString:@"gameTitle"])
		{
			if(![[change objectForKey:NSKeyValueChangeNewKey] isEqualToString:[change objectForKey:NSKeyValueChangeOldKey]])
			{
				if(self.gameAndMode.selected == NO)
				{
					formProgress = formProgress | ValidGameTitle;
					self.gameAndMode.selected = YES;
				}
			}
		}
		else if([keyPath isEqualToString:@"gameMode"])
		{
			if(![[change objectForKey:NSKeyValueChangeNewKey] isEqualToString:[change objectForKey:NSKeyValueChangeOldKey]])
			{
				formProgress = formProgress | ValidGameMode;
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
			
		}
		else if([keyPath isEqualToString:@"description"])
		{
			
		}
	}
	

	//NSLog(@"%@", change);
}

- (void)dismissModalViewController
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectPlatform
{
	GMRChoosePlatformController * controller = [[GMRChoosePlatformController alloc] initWithNibName:nil 
																							 bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (IBAction)selectGameAndMode
{
	GMRChooseGameAndMode * controller = [[GMRChooseGameAndMode alloc] initWithNibName:nil 
																			   bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (IBAction)selectAvailability
{	
	GMRChooseAvailability * controller = [[GMRChooseAvailability alloc] initWithNibName:nil 
																			     bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (IBAction)selectPlayers
{
	GMRChoosePlayers * controller = [[GMRChoosePlayers alloc] initWithNibName:nil 
																	   bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (IBAction)selectTime
{
	NSLog(@"%f, %f", self.time.frame.size.width, self.time.frame.size.height);
}

- (IBAction)selectDescription
{
	NSLog(@"%f, %f", self.description.frame.size.width, self.description.frame.size.height);
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
							  forKeyPath:@"gameTitle"];
	
	[kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"gameMode"];
	
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
