//
//  GMRGame.m
//  Gamer
//
//  Created by Adam Venturella on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRGame.h"
#import "GMRClient.h"

@implementation GMRGame
@synthesize id, label, modes, maxPlayers, selectedMode, platform;

+ (id)gameWithDicitonary:(NSDictionary *)dictionary
{
	GMRGame * game = [[GMRGame alloc] init];
	[game setValuesForKeysWithDictionary:dictionary];
	
	return [game autorelease];
}

- (id)init
{
	self = [super init];
	
	if(self)
	{
		self.selectedMode = -1;
	}
	
	return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
	if([key isEqualToString:@"platform"])
		self.platform = [GMRClient platformForString:value];
	else 
		[super setValue:value forKey:key];
}

- (void)dealloc
{
	self.id    = nil;
	self.label = nil;
	self.modes = nil;
	
	[super dealloc];
}
@end
