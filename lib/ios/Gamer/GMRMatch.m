//
//  GMRGame.m
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRMatch.h"


@implementation GMRMatch
@synthesize platform, gameId, gameTitle, gameMode, players, time, description;

- (void)dealloc
{
	self.gameId      = nil;
	self.gameTitle   = nil;
	self.gameMode    = nil;
	self.players     = nil;
	self.time        = nil;
	self.description = nil;
	
	[super dealloc];
}
@end
