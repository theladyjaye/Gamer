//
//  InitializationTests.m
//  Gamer
//
//  Created by Adam Venturella on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InitializationTests.h"
#import "GMRClient.h"

#define USERNAME       @"aventurella"
#define PASSWORD       @"12345"
#define VERSION        @"0.2"
#define GAME_ID        @"halo-reach"
#define GAME_LABEL     @"Halo:Reach"

#define USER_1         @"aventurella"
#define USER_2         @"bpuglisi"
#define API_KEY_USER_1 @"359390f17f9ce566c7248b8b111ab4f8"
#define API_KEY_USER_2 @"0d266a3aed2466c265c0aa401b073cd7"

#define USER_1_SCHEDULED_MATCHES 4

#define MATCHES_XBOX360_HOUR 3
#define MATCHES_XBOX360_30MIN 2
#define MATCHES_XBOX360_15MIN 1

#define MATCHES_XBOX360_HOUR_HALO_REACH 2


static GMRClient * client;
static NSString * kCreatedMatchId1;

@implementation InitializationTests


- (void) setUp 
{
	if(!client)
	{
		client = [[GMRClient alloc] init];
		STAssertNotNil(client, @"Could not create GMRClient.");
	}
}

- (void) tearDown 
{
	//NSLog(@"tearDown");
	//[client release];
}
	
- (void)testPlatformStrings
{
	STAssertTrue(@"xbox360" == [GMRClient stringForPlatform:GMRPlatformXBox360], @"GMRPlatformXBox360 does not equal xbox360");
	STAssertTrue(@"wii" == [GMRClient stringForPlatform:GMRPlatformWii], @"GMRPlatformWii does not equal wii");
	STAssertTrue(@"playstation3" == [GMRClient stringForPlatform:GMRPlatformPlaystation3], @"GMRPlatformPlaystation3 does not equal playstation3");
	STAssertTrue(@"playstation2" == [GMRClient stringForPlatform:GMRPlatformPlaystation2], @"GMRPlatformPlaystation2 does not equal playstation2");
	STAssertTrue(@"pc" == [GMRClient stringForPlatform:GMRPlatformPC], @"GMRPlatformPC does not equal pc");
}

- (void)testAuthenticateUser
{
	[client authenticateUser:USERNAME password:PASSWORD withCallback:^(BOOL ok, NSDictionary * response){
		NSString * token = [response objectForKey:@"token"];
		
		STAssertTrue(ok, [NSString stringWithFormat:@"Could not authenticate user %@ with password %@", USERNAME, PASSWORD]);
		STAssertTrue([token isEqualToString:API_KEY_USER_1], [NSString stringWithFormat:@"Expected token %@ got:%@", API_KEY_USER_1, token]);
		
		client.apiKey   = API_KEY_USER_1;
		client.username = USERNAME;
		
		STAssertTrue([client.apiKey isEqualToString:token], [NSString stringWithFormat:@"Expected client token %@ got:%@", token, client.apiKey]);
	}];
}

- (void)testVersion
{
	[client version:^(BOOL ok, NSDictionary * response){
		
		NSString * version = [response objectForKey:@"version"];
		STAssertTrue(ok, @"Could not access version endpoint");
		STAssertTrue([version isEqualToString:VERSION], [NSString stringWithFormat:@"Invalid version. Expecting %@ got %@", VERSION, version]);
	}];
}


- (void)testGamesForPlatform
{
	[client gamesForPlatform:GMRPlatformXBox360 withCallback:^(BOOL ok, NSDictionary * response)
	{
		NSArray * games = [response objectForKey:@"games"];
		
		STAssertTrue(ok, @"Api Returned false for: gamesForPlatform:withCallback:");
		STAssertTrue([games count] == 3, [NSString stringWithFormat:@"Expected 3 Games Returned, got %i", [games count]]);
	}];
}

- (void)testSearchPlatformForGame
{
	[client searchPlatform:GMRPlatformPC forGame:@"STARCRAFT" withCallback:^(BOOL ok, NSDictionary * response)
	{
		NSArray * games = [response objectForKey:@"games"];
		NSString * label;
		
		STAssertTrue(ok, @"Api Returned false for: searchPlatform:forGame:withCallback:");
		STAssertTrue([games count] == 1, [NSString stringWithFormat:@"Expected 1 Game Returned, got %i", [games count]]);
		
		label = [[games objectAtIndex:0] objectForKey:@"label"];
		
		STAssertTrue([label isEqualToString:@"Starcraft 2"], [NSString stringWithFormat:@"Expected 'Starcraft 2' got %@", label]);
	}];
	
}

- (void)testMatch1Create
{
	NSDate * date = [NSDate dateWithTimeIntervalSinceNow:1800];
	
	[client matchCreate:date 
				 gameId:GAME_ID 
			   platform:GMRPlatformXBox360 
		   availability:GMRMatchAvailabliltyPublic 
			 maxPlayers:4
		 invitedPlayers:nil//[NSArray arrayWithObjects:USER_2, nil]
				  label:@"My first iPhone test game"
		   withCallback:^(BOOL ok, NSDictionary * response){
			   STAssertTrue(ok, @"Unable to create match");
			   
			   kCreatedMatchId1 = [response objectForKey:@"match"];
			   [kCreatedMatchId1 retain];
		   }];
}

- (void)testMatch2Scheduled
{
	[client matchesScheduled:^(BOOL ok, NSDictionary * response){
		NSArray * matches = [response objectForKey:@"matches"];
		
		STAssertTrue(ok, @"Unable to get Scheduled Matches");
		STAssertTrue([matches count] == (USER_1_SCHEDULED_MATCHES + 1), [NSString stringWithFormat:@"Expected %i scheduled matches got %i", (USER_1_SCHEDULED_MATCHES + 1), [matches count]]);
	}];
}

- (void)testMatch3Join
{
	GMRClient * gmrClient = [[GMRClient alloc] initWithKey:API_KEY_USER_2 andName:USER_2];
	
	[gmrClient matchJoin:GMRPlatformXBox360 
				gameId:GAME_ID 
			   matchId:kCreatedMatchId1 withCallback:^(BOOL ok, NSDictionary * response)
	 {
		 STAssertTrue(ok, @"Unable to join match");
		 [gmrClient release];
	 }];
}

- (void)testMatch4Leave
{
	GMRClient * gmrClient = [[GMRClient alloc] initWithKey:API_KEY_USER_2 andName:USER_2];
	
	[gmrClient matchLeave:GMRPlatformXBox360 
				gameId:GAME_ID 
			   matchId:kCreatedMatchId1 withCallback:^(BOOL ok, NSDictionary * response)
	 {
		 STAssertTrue(ok, @"Unable to leave match");
		 [gmrClient release];
	 }];
}

- (void)testMatch5Cancel
{
	GMRClient * gmrClient = [[GMRClient alloc] initWithKey:API_KEY_USER_1 andName:USER_1];
	[gmrClient matchLeave:GMRPlatformXBox360 
				   gameId:GAME_ID
				  matchId:kCreatedMatchId1 withCallback:^(BOOL ok, NSDictionary * response)
	 {
		 STAssertTrue(ok, @"Unable to cancel match");
		 [gmrClient release];
	 }];
}

- (void)testMatch6Scheduled
{
	[client matchesScheduled:^(BOOL ok, NSDictionary * response){
		NSArray * matches = [response objectForKey:@"matches"];
		
		STAssertTrue(ok, @"Unable to get Scheduled Matches");
		STAssertTrue([matches count] == USER_1_SCHEDULED_MATCHES, [NSString stringWithFormat:@"Expected %i scheduled matches got %i", USER_1_SCHEDULED_MATCHES, [matches count]]);
	}];
}

- (void)testMatchesForIntervalHour
{
	[client matchesScheduledForPlatform:GMRPlatformXBox360 
						andTimeInterval:GMRTimeIntervalHour 
						   withCallback:^(BOOL ok, NSDictionary * response){
							   NSArray * matches = [response objectForKey:@"matches"];
							   
							   STAssertTrue(ok, @"Unable to get Scheduled Matches For Xbox360 in within the hour"); 
							   STAssertTrue([matches count] == MATCHES_XBOX360_HOUR, [NSString stringWithFormat:@"Expected %i scheduled matches on Xbox 360 within the hour got %i", MATCHES_XBOX360_HOUR, [matches count]]);
						   }];
}


- (void)testMatchesForInterval30min
{
	[client matchesScheduledForPlatform:GMRPlatformXBox360 
						andTimeInterval:GMRTimeInterval30Min
						   withCallback:^(BOOL ok, NSDictionary * response){
							   NSArray * matches = [response objectForKey:@"matches"];
							   
							   STAssertTrue(ok, @"Unable to get Scheduled Matches For Xbox360 in within 30min");
							   STAssertTrue([matches count] == MATCHES_XBOX360_30MIN, [NSString stringWithFormat:@"Expected %i scheduled matches on Xbox 360 within 30min got %i", MATCHES_XBOX360_30MIN, [matches count]]);
						   }];
	
}

- (void)testMatchesForInterval15min
{
	[client matchesScheduledForPlatform:GMRPlatformXBox360 
						andTimeInterval:GMRTimeInterval15Min
						   withCallback:^(BOOL ok, NSDictionary * response){
							   NSArray * matches = [response objectForKey:@"matches"];
							   
							   STAssertTrue(ok, @"Unable to get Scheduled Matches For Xbox360 in within 15min"); 
							   STAssertTrue([matches count] == MATCHES_XBOX360_15MIN, [NSString stringWithFormat:@"Expected %i scheduled matches on Xbox 360 within 15min got %i", MATCHES_XBOX360_15MIN, [matches count]]);
						   }];
	
}

- (void)testMatchesForGameAndIntervalHour
{
	[client matchesScheduledForPlatform:GMRPlatformXBox360 
								andGame:GAME_ID 
						andTimeInterval:GMRTimeIntervalHour 
						   withCallback:^(BOOL ok, NSDictionary * response){
							   
							   STAssertTrue(ok, @"Unable to get Scheduled Matches For Xbox360 And Halo Reach in within the hour"); 
							   
							   NSDictionary * game  = [response objectForKey:@"game"];
							   NSArray * matches    = [response objectForKey:@"matches"];
							   NSString * gameLabel = (NSString *)[game objectForKey:@"label"];
							   
							   STAssertTrue([gameLabel isEqualToString:GAME_LABEL], [NSString stringWithFormat:@"Expected Halo:Reach got %@", [game objectForKey:@"label"]]);
							   STAssertTrue([matches count] == MATCHES_XBOX360_HOUR_HALO_REACH, [NSString stringWithFormat:@"Expected %i scheduled matches on Xbox 360 for Halo Reach within the hour got %i", MATCHES_XBOX360_HOUR_HALO_REACH, [matches count]]);
						   }];
	
}




@end
