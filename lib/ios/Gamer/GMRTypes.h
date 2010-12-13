//
//  GMRUtils.h
//  Gamer
//
//  Created by Adam Venturella on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

enum{
	GMRMatchAvailabliltyUnknown,
	GMRMatchAvailabliltyPublic,
	GMRMatchAvailabliltyPrivate
};
typedef NSUInteger GMRMatchAvailablilty;

/*enum {
	GMRPlatformUnknown,
	GMRPlatformXBox360,
	GMRPlatformWii,
	GMRPlatformPlaystation3,
	GMRPlatformPlaystation2,
	GMRPlatformPC,
	GMRPlatformBattleNet,
	GMRPlatformSteam
	
};*/

// This NEEDS to be alphabetized
enum {
	GMRPlatformUnknown,
	GMRPlatformBattleNet,
	GMRPlatformPC,
	GMRPlatformPlaystation2,
	GMRPlatformPlaystation3,
	GMRPlatformSteam,
	GMRPlatformWii,
	GMRPlatformXBox360
};
typedef NSUInteger GMRPlatform;

enum {
	GMRTimeIntervalHour,
	GMRTimeInterval30Min,
	GMRTimeInterval15Min
};
typedef NSUInteger GMRTimeInterval;


typedef void (^GMRCallback)(BOOL, NSDictionary *);
