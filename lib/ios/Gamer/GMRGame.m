//
//  GMRGame.m
//  Gamer
//
//  Created by Adam Venturella on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRGame.h"


@implementation GMRGame
@synthesize id, label, modes, maxPlayers, selectedMode;

- (id)init
{
	self = [super init];
	
	if(self)
	{
		self.selectedMode = -1;
	}
	
	return self;
}

- (void)dealloc
{
	self.id    = nil;
	self.label = nil;
	self.modes = nil;
	
	[super dealloc];
}
@end
