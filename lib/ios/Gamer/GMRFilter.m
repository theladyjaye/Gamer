//
//  GMRFilter.m
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRFilter.h"
#import "GMRGame.h"

@implementation GMRFilter
@synthesize timeInterval, platform, game;

- (void)dealloc
{
	self.game = nil;
	[super dealloc];
}
@end
