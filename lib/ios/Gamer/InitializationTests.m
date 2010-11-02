//
//  InitializationTests.m
//  Gamer
//
//  Created by Adam Venturella on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InitializationTests.h"
#import "GMRClient.h"

@implementation InitializationTests


- (void) setUp 
{
	client = [[GMRClient alloc] initWithKey:@"12345"];
	STAssertNotNil(client, @"Could not create GMRClient.");
}

- (void) tearDown 
{
	[client release];
}
	
- (void)testPlatformStrings
{
	STAssertTrue(@"xbox360" == [client stringForPlatform:GMRPlatformXBox360], @"GMRPlatformXBox360 does not equal xbox360");
	STAssertTrue(@"wii" == [client stringForPlatform:GMRPlatformWii], @"GMRPlatformWii does not equal wii");
	STAssertTrue(@"playstation3" == [client stringForPlatform:GMRPlatformPlaystation3], @"GMRPlatformPlaystation3 does not equal playstation3");
	STAssertTrue(@"playstation2" == [client stringForPlatform:GMRPlatformPlaystation2], @"GMRPlatformPlaystation2 does not equal playstation2");
	STAssertTrue(@"pc" == [client stringForPlatform:GMRPlatformPC], @"GMRPlatformPC does not equal pc");
}

- (void)testGamesForPlatform
{
	[client gamesForPlatform:GMRPlatformXBox360 withCallback:^(NSString * response)
	{
		STAssertTrue(response == @"xbox360", [NSString stringWithFormat:@"Expected xbox360 got %@", response]);
	}];
}

- (void)testMatchJoin
{
	[client matchJoin:@"bpuglsi" 
			  platform:GMRPlatformXBox360 
				gameId:@"halo-reach" 
			   matchId:@"afd59a" withCallback:^(NSString * response)
	 {
		 //STAssertTrue(response == @"xbox360", [NSString stringWithFormat:@"Expected xbox360 got %@", response]);
	 }];
}

- (void)testMatchLeave
{
	[client matchLeave:@"bpuglsi" 
			  platform:GMRPlatformXBox360 
				gameId:@"halo-reach" 
			   matchId:@"afd59a" withCallback:^(NSString * response)
	 {
		 //STAssertTrue(response == @"xbox360", [NSString stringWithFormat:@"Expected xbox360 got %@", response]);
	 }];
}



@end
