//
//  GMRAlias.m
//  Gamer
//
//  Created by Adam Venturella on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRAlias.h"
#import "GMRClient.h"
#import "GMRTypes.h"

@implementation GMRAlias
@synthesize platform, alias;

+ (id)aliasWithDicitonary:(NSDictionary *)dictionary
{
	GMRAlias * alias = [[GMRAlias alloc] init];
	alias.platform = [GMRClient platformForString:[dictionary valueForKey:@"platform"]];
	alias.alias    = [dictionary valueForKey:@"alias"];	
	return [alias autorelease];
}

- (void)dealloc
{
	self.alias = nil;
	[super dealloc];
}
@end
