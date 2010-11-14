//
//  GMRMatchListCell.m
//  Gamer
//
//  Created by Adam Venturella on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRMatchListCell.h"


@implementation GMRMatchListCell
@synthesize label, game, players, date, mode;

- (void)dealloc
{
	self.label = nil;
	self.game = nil;
	self.players = nil;
	self.date = nil;
	self.mode = nil;
	[super dealloc];
}

@end
