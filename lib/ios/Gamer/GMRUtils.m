//
//  GMRUtils.m
//  Gamer
//
//  Created by Adam Venturella on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// http://github.com/lukeredpath/LROAuth2Client
// NSDictionary+QueryString & NSString+QueryString

#import "GMRUtils.h"


@implementation GMRUtils
+(NSString *)formEncodedStringFromDictionary:(NSDictionary *)value
{
	NSMutableArray* arguments = [NSMutableArray arrayWithCapacity:[value count]];
	
	for (NSString* key in value)
	{
		if([[value objectForKey:key] isKindOfClass:[NSArray class]])
		{
			NSArray * arrayParam = (NSArray *)[value objectForKey:key];
			
			for(NSString * item in arrayParam)
			{
				[arguments addObject:[NSString stringWithFormat:@"%@[]=%@",
									  [GMRUtils formEncodedStringFromString:key],
									  [GMRUtils formEncodedStringFromString:item]]];
			}
		}
		else 
		{
			[arguments addObject:[NSString stringWithFormat:@"%@=%@",
								  [GMRUtils formEncodedStringFromString:key],
								  [GMRUtils formEncodedStringFromString:[[value objectForKey:key] description]]]];
		}
	}
	
	return [arguments componentsJoinedByString:@"&"];
}

+ (NSString *)formEncodedStringFromString:(NSString *)value
{
	NSString *result = value;
	
	CFStringRef originalAsCFString = (CFStringRef) value;
	CFStringRef leaveAlone = CFSTR(" ");
	CFStringRef toEscape = CFSTR("\n\r?[]()$,!'*;:@&=#%+/");
	
	CFStringRef escapedStr;
	escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, originalAsCFString, leaveAlone, toEscape, kCFStringEncodingUTF8);
	
	if (escapedStr) {
		NSMutableString *mutable = [NSMutableString stringWithString:(NSString *)escapedStr];
		CFRelease(escapedStr);
		
		[mutable replaceOccurrencesOfString:@" " withString:@"+" options:0 range:NSMakeRange(0, [mutable length])];
		result = mutable;
	}
	
	return result;  
}
@end
