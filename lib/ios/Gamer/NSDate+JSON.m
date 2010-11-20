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

+ (NSString *)gamerScheduleTimeString:(NSString *)scheduled_time
{
	// TODO: need to let the user configure how they want their time.
	
	NSDate * date = [NSDate dateWithJSONString:scheduled_time];
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	
	[formatter setDateFormat:@"EEE, LLL dd hh:mm a"];
	NSString * displayDate = [formatter stringFromDate:date];
	[formatter release];
	
	return displayDate;
}
@end








