//
//  GMRFilter.m
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRFilter.h"
#import "GMRGame.h"
#import <CommonCrypto/CommonDigest.h> 

@implementation GMRFilter
@synthesize timeInterval, platform, game;

+ (GMRFilter *)filterWithFilter:(GMRFilter *)filter
{
	GMRFilter * object    = [[GMRFilter alloc] init];
	object.timeInterval = filter.timeInterval;
	object.platform     = filter.platform;
	
	if(filter.game)
		object.game = filter.game;
	
	return [object autorelease];
}

- (id)init
{
	self = [super init];
	
	if(self)
	{
		self.platform     = GMRPlatformUnknown;
		self.timeInterval = GMRTimeInterval15Min;
	}
	
	return self;
}



- (NSString *) description
{
	const char *cStr;
	
	if(self.game)
	{
		cStr = [[NSString stringWithFormat:@"%i%i%@", self.timeInterval, self.platform, self.game.id] UTF8String];
	}
	else 
	{
		cStr = [[NSString stringWithFormat:@"%i%i", self.timeInterval, self.platform] UTF8String];
	}
		

    unsigned char result[16];
	
    CC_MD5( cStr, strlen(cStr), result );
	
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			]; 
}

- (void)dealloc
{
	self.game = nil;
	[super dealloc];
}
@end
