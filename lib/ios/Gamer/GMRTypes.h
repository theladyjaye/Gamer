//
//  GMRUtils.h
//  Gamer
//
//  Created by Adam Venturella on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

enum{
	GMRMatchAvailabliltyPublic,
	GMRMatchAvailabliltyPrivate,
};
typedef NSUInteger GMRMatchAvailablilty;

enum {
	GMRPlatformXBox360,
	GMRPlatformWii,
	GMRPlatformPlaystation3,
	GMRPlatformPlaystation2,
	GMRPlatformPC
};
typedef NSUInteger GMRPlatform;

typedef void (^GMRCallback)(BOOL, NSDictionary *);
