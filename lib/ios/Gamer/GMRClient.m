//
//  GMRClient.m
//  Gamer
//
//  Created by Adam Venturella on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRClient.h"
#import "GMRTypes.h"
#import "GMRRequest.h"

static NSArray * platformStrings;

@implementation GMRClient

+(void)initialize
{
	platformStrings = [NSArray arrayWithObjects:@"xbox360", 
					                            @"wii",
					                            @"playstation3",
					                            @"playstation2",
					                            @"pc",
												nil];
	[platformStrings retain];
}

- (GMRClient *)initWithKey:(NSString *)key
{
	self = [super init];
	
	if(self)
	{
		apiRequest     = [[GMRRequest alloc] init];
		apiRequest.key = key;
	}
	
	return self;
}


- (NSString *)stringForPlatform:(GMRPlatform)platform
{
	return [platformStrings objectAtIndex:platform];
}


- (void)gamesForPlatform:(GMRPlatform)platform withBlock:(GMRCallback)callback
{
	NSString*     method = @"GET";
	NSString*     path   = [NSString stringWithFormat:@"/games/%@", [self stringForPlatform:platform]];
	NSDictionary* query  = [NSDictionary dictionaryWithObjectsAndKeys:@"3", @"limit", nil];
	
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", query, @"query", nil] 
		   withCallback:^(NSString * response){
			   NSLog(@"gamesForPlatform 1: %@", response);
			   callback([self stringForPlatform:GMRPlatformXBox360]);
		   }];
}

- (void)dealloc
{
	[apiRequest release];
	[super dealloc];
}



@end
