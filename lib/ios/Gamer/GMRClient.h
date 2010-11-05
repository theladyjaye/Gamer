//
//  GMRClient.h
//  Gamer
//
//  Created by Adam Venturella on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define GAMER_TESTING 1

#import <Foundation/Foundation.h>
#import "GMRTypes.h"


@class GMRRequest;
@interface GMRClient : NSObject
{
	GMRRequest * apiRequest;
}


- (GMRClient *)initWithKey:(NSString *)key;
- (NSString *)stringForPlatform:(GMRPlatform)platform;
- (void)searchPlatform:(GMRPlatform)platform forGame:(NSString *)query withCallback:(GMRCallback)callback;
- (void)gamesForPlatform:(GMRPlatform)platform withCallback:(GMRCallback)callback;
- (void)matchCreate:(NSDate *)scheduledTime gameId:(NSString *)gameId platform:(GMRPlatform) availability:(GMRMatchAvailablilty)availability maxPlayers:(NSUInteger) invitedPlayers:(NSArray *)invitedPlayers label:(NSString *)label;
- (void)matchJoin:(NSString *)username platform:(GMRPlatform)platform gameId:(NSString *)gameId matchId:(NSString *)matchId withCallback:(GMRCallback)callback;
- (void)matchLeave:(NSString *)username platform:(GMRPlatform)platform gameId:(NSString *)gameId matchId:(NSString *)matchId withCallback:(GMRCallback)callback;


@end