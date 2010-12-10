//
//  GMRGame.m
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRMatch.h"
#import "GMRGame.h"
#import "GMRTypes.h"
#import "GMRClient.h"
#import "NSDate+JSON.h"

@implementation GMRMatch
@synthesize platform, game, availability, scheduled_time, label, maxPlayers, mode, created_by, id;

+ (id)matchWithDicitonary:(NSDictionary *)dictionary
{
	GMRMatch * match        = [[GMRMatch alloc] init];
	match.id                = [dictionary objectForKey:@"_id"];
	match.game              = [GMRGame gameWithDicitonary:[dictionary objectForKey:@"game"]];
	match.platform          = [GMRClient platformForString:[dictionary valueForKeyPath:@"game.platform"]];
	match.created_by        = [dictionary objectForKey:@"created_by"];
	match.mode              = [dictionary objectForKey:@"mode"];
	match.scheduled_time    = [NSDate dateWithJSONString:[dictionary objectForKey:@"scheduled_time"]];
	match.label             = [dictionary objectForKey:@"label"];
	match.maxPlayers        = [[dictionary objectForKey:@"maxPlayers"] intValue];
	match.availability      = [[dictionary objectForKey:@"availability"] isEqualToString:@"public"] ? GMRMatchAvailabliltyPublic : GMRMatchAvailabliltyPrivate; 
	match.game.selectedMode = [match.game.modes indexOfObject:match.mode];
	return [match autorelease];
}

- (void)dealloc
{
	self.game           = nil;
	self.scheduled_time = nil;
	self.label          = nil;
	self.mode           = nil;
	self.created_by     = nil;
	self.id             = nil;
	
	[super dealloc];
}
@end
