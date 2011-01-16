//
//  GMRHashing.m
//  Gamer
//
//  Created by Adam Venturella on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GMRHashing.h"
#import <CommonCrypto/CommonDigest.h>

@implementation GMRHashing

+ (NSString *)md5:(NSString *)string
{
	unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
	
	CC_MD5([string UTF8String], [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
	
	NSMutableString *ms = [NSMutableString string];
	
	for (i=0; i < CC_MD5_DIGEST_LENGTH; i++) 
	{
		[ms appendFormat: @"%02x", (int)(digest[i])];
	}
	
	return [[ms copy] autorelease];
}

@end
