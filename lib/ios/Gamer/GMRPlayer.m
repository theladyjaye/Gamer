//
//  GMRPlayer.m
//  Gamer
//
//  Created by Adam Venturella on 12/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRPlayer.h"


@implementation GMRPlayer
@synthesize alias, username;

+ (GMRPlayer *)playerWithDicitonary:(NSDictionary *)dictionary;
{
	GMRPlayer * object = [[GMRPlayer alloc] init];
	[object setValuesForKeysWithDictionary:dictionary];
	
	return [object autorelease];
}

- (void)dealloc
{
	self.alias = nil;
	self.username = nil;
	[super dealloc];
}
@end
