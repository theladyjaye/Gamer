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
#define API_KEY  @"359390f17f9ce566c7248b8b111ab4f8"
#define VERSION  @"0.2"

static GMRClient * client;

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
		STAssertTrue([token isEqualToString:API_KEY], [NSString stringWithFormat:@"Expected token %@ got:%@", API_KEY, token]);
		
		client.apiKey   = token;
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

- (void)testMatchJoin
{
	[client matchJoin:GMRPlatformXBox360 
				gameId:@"halo-reach" 
			   matchId:@"afd59a" withCallback:^(BOOL ok, NSDictionary * response)
	 {
		 //STAssertTrue(response == @"xbox360", [NSString stringWithFormat:@"Expected xbox360 got %@", response]);
	 }];
}

- (void)testMatchLeave
{
	[client matchLeave:GMRPlatformXBox360 
				gameId:@"halo-reach" 
			   matchId:@"afd59a" withCallback:^(BOOL ok, NSDictionary * response)
	 {
		 //STAssertTrue(response == @"xbox360", [NSString stringWithFormat:@"Expected xbox360 got %@", response]);
	 }];
}



@end
