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


- (void)gamesForPlatform:(GMRPlatform)platform withCallback:(GMRCallback)callback
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

- (void)matchJoin:(NSString *)username platform:(GMRPlatform)platform gameId:(NSString *)gameId matchId:(NSString *)matchId withCallback:(GMRCallback)callback
{
	NSString*     method = @"POST";
	NSString*     path   = [NSString stringWithFormat:@"/matches/%@/%@/%@/%@", [self stringForPlatform:platform],
							gameId,
							matchId,
							username];
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", nil] 
		   withCallback:^(NSString * response){
			   NSLog(@"Join 1: %@", response);
			   callback([self stringForPlatform:GMRPlatformXBox360]);
		   }];
	
}

- (void)matchLeave:(NSString *)username platform:(GMRPlatform)platform gameId:(NSString *)gameId matchId:(NSString *)matchId withCallback:(GMRCallback)callback
{
	NSString*     method = @"DELETE";
	NSString*     path   = [NSString stringWithFormat:@"/matches/%@/%@/%@/%@", [self stringForPlatform:platform],
							gameId,
							matchId,
							username];
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", nil] 
		   withCallback:^(NSString * response){
			   NSLog(@"Leave 1: %@", response);
			   callback([self stringForPlatform:GMRPlatformXBox360]);
		   }];
	
}

- (void)dealloc
{
	apiRequest = nil;
	[super dealloc];
}



@end
