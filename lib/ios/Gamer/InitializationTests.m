//
//  InitializationTests.m
//  Gamer
//
//  Created by Adam Venturella on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InitializationTests.h"
#import "GMRClient.h"

#define USERNAME @"aventurella"
#define PASSWORD @"12345"
#define VERSION  @"0.2"
#define GAME_ID  @"halo-reach"

#define USER_1   @"aventurella"
#define USER_2   @"bpuglisi"
#define API_KEY_USER_1 @"359390f17f9ce566c7248b8b111ab4f8"
#define API_KEY_USER_2 @"0d266a3aed2466c265c0aa401b073cd7"


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
	STAssertTrue(@"xbox360" == [client stringForPlatform:GMRPlatformXBox360], @"GMRPlatformXBox360 does not equal xbox360");
	STAssertTrue(@"wii" == [client stringForPlatform:GMRPlatformWii], @"GMRPlatformWii does not equal wii");
	STAssertTrue(@"playstation3" == [client stringForPlatform:GMRPlatformPlaystation3], @"GMRPlatformPlaystation3 does not equal playstation3");
	STAssertTrue(@"playstation2" == [client stringForPlatform:GMRPlatformPlaystation2], @"GMRPlatformPlaystation2 does not equal playstation2");
	STAssertTrue(@"pc" == [client stringForPlatform:GMRPlatformPC], @"GMRPlatformPC does not equal pc");
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
			   NSLog(@"Created Game: %@", kCreatedMatchId1);
		   }];
}

- (void)testMatch2Join
{
	GMRClient * gmrClient = [[GMRClient alloc] initWithKey:API_KEY_USER_2 andName:USER_2];
	
	[gmrClient matchJoin:GMRPlatformXBox360 
				gameId:GAME_ID 
			   matchId:kCreatedMatchId1 withCallback:^(BOOL ok, NSDictionary * response)
	 {
		 STAssertTrue(ok, @"Unable to join match");
		 NSLog(@"Joined Game Response %@", response);
		 [gmrClient release];
	 }];
}

- (void)testMatch3Leave
{
	GMRClient * gmrClient = [[GMRClient alloc] initWithKey:API_KEY_USER_2 andName:USER_2];
	NSLog(@"Leaving Match: %@", kCreatedMatchId1);
	
	[gmrClient matchLeave:GMRPlatformXBox360 
				gameId:GAME_ID 
			   matchId:kCreatedMatchId1 withCallback:^(BOOL ok, NSDictionary * response)
	 {
		 NSLog(@"Leave Response %@", response);
		 STAssertTrue(ok, @"Unable to leave match");
		 [gmrClient release];
	 }];
}

- (void)testMatch4Cancel
{
	GMRClient * gmrClient = [[GMRClient alloc] initWithKey:API_KEY_USER_1 andName:USER_1];
	[gmrClient matchLeave:GMRPlatformXBox360 
				   gameId:GAME_ID
				  matchId:kCreatedMatchId1 withCallback:^(BOOL ok, NSDictionary * response)
	 {
		 NSLog(@"Cancel Response %@", response);
		 STAssertTrue(ok, @"Unable to cancel match");
		 [gmrClient release];
	 }];
}



@end
