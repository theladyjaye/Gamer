//
//  GMRGame.m
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRMatch.h"
#import "GMRGame.h"

@implementation GMRMatch
@synthesize platform, game, availability, players, time, description;

- (void)dealloc
{
	self.game         = nil;
	self.availability = nil;
	self.time         = nil;
	self.description  = nil;
	
	[super dealloc];
}
@end
