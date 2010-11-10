//
//  NSDateFormatter+JSON.m
//  Gamer
//
//  Created by Adam Venturella on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSDate+JSON.h"


@implementation NSDate(JSON)

+ (NSDate *)dateWithJSONString:(NSString *)string
{
	// 2010-11-10T06:20:23.000Z
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
	
	NSDate *date = [dateFormatter dateFromString:string];
	[dateFormatter release];
	
	return date;
}
@end
