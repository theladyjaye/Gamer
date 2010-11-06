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

- (id)init
{
	self = [super init];
	
	if(self)
	{
		apiRequest = [[GMRRequest alloc] init];
	}
	
	return self;
}

- (GMRClient *)initWithKey:(NSString *)key
{
	self = [self init];
	
	if(self)
	{
		apiRequest.key = key;
	}
	
	return self;
}

- (NSString *)apiKey
{
	return apiRequest.key;
}

- (void)setApiKey:(NSString *)value
{
	apiRequest.key = value;
}

- (NSString *)stringForPlatform:(GMRPlatform)platform
{
	return [platformStrings objectAtIndex:platform];
}

- (void)authenticateUser:(NSString *)username password:(NSString *)password withCallback:(GMRCallback)callback
{
	NSString*      method = @"POST";
	NSString*      path   = @"http://hazgame.com/accounts/login";
	NSDictionary * data  = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", nil];
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", data, @"data", nil]
		   withCallback:^(BOOL ok, NSDictionary * response){
			   callback(ok, response);
		   }];
	
}

- (void)version:(GMRCallback)callback
{
	NSString*     method = @"GET";
	NSString*     path   = @"/system/version";
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", nil] 
		   withCallback:^(BOOL ok, NSDictionary * response){
			   callback(ok, response);
		   }];
}


- (void)searchPlatform:(GMRPlatform)platform forGame:(NSString *)query withCallback:(GMRCallback)callback
{
	NSString*     method = @"GET";
	NSString*     path   = [NSString stringWithFormat:@"/games/%@/search/%@", [self stringForPlatform:platform], query];
	
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", nil] 
		   withCallback:^(BOOL ok, NSDictionary * response){
			   callback(ok, response);
		   }];
	
}

- (void)gamesForPlatform:(GMRPlatform)platform withCallback:(GMRCallback)callback
{
	NSString*     method = @"GET";
	NSString*     path   = [NSString stringWithFormat:@"/games/%@", [self stringForPlatform:platform]];
	NSDictionary* query  = [NSDictionary dictionaryWithObjectsAndKeys:@"3", @"limit", nil];
	
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", query, @"query", nil] 
		   withCallback:^(BOOL ok, NSDictionary * response){
			   callback(ok, response);
		   }];
}

- (void)matchCreate:(NSDate *)scheduledTime gameId:(NSString *)gameId platform:(GMRPlatform) availability:(GMRMatchAvailablilty)availability maxPlayers:(NSUInteger) invitedPlayers:(NSArray *)invitedPlayers label:(NSString *)label
{
	/*
	 public function matchCreate($owner, DateTime $scheduled_time, $game_id, $platform, $availability, $maxPlayers, $invited_players=null, $label=null)
	 {
	 $scheduled_time->setTimezone(new DateTimeZone('UTC'));
	 
	 $response = $this->request->execute(array('path'          => '/matches/'.$platform.'/'.$game_id,
	 'data'          => array('username'       => $owner,
	 'scheduled_time' => $scheduled_time->format('Y-m-d\TH:i:s\Z'), // pretty much DateTime::ISO8601 but instead of Y-m-d\TH:i:sO it's Y-m-d\TH:i:s\Z (note the Z - Zulu time) compatible with JavaScript
	 'availability'   => $availability,
	 'maxPlayers'     => $maxPlayers,
	 'label'          => $label,
	 'players'        => $invited_players),
	 'method'        => 'POST'));
	 
	 $data = json_decode($response);
	 
	 if($data->ok)
	 return $data->match;
	 
	 return false;
	 }
	 */
}

- (void)matchJoin:(NSString *)username platform:(GMRPlatform)platform gameId:(NSString *)gameId matchId:(NSString *)matchId withCallback:(GMRCallback)callback
{
	NSString*     method = @"POST";
	NSString*     path   = [NSString stringWithFormat:@"/matches/%@/%@/%@/%@", [self stringForPlatform:platform],
							gameId,
							matchId,
							username];
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", nil] 
		   withCallback:^(BOOL ok, NSDictionary * response){
			   callback(ok, response);
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
		   withCallback:^(BOOL ok, NSDictionary * response){
			   callback(ok, response);
		   }];
	
}

- (void)dealloc
{
	apiRequest = nil;
	[super dealloc];
}



@end
