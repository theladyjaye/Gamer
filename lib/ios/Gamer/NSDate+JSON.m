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

+ (NSString *)dateToJSONString:(NSDate *)date
{
	// 2010-11-10T06:20:23.000Z
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
	
	NSString* string = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	
	return string;
}

+ (NSString *)gamerScheduleTimeString:(NSDate *)scheduled_time
{
	// TODO: need to let the user configure how they want their time.
	
	//NSDate * date = [NSDate dateWithJSONString:scheduled_time];
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	
	[formatter setDateFormat:@"EEE, LLL dd hh:mm a"];
	NSString * displayDate = [formatter stringFromDate:scheduled_time];
	[formatter release];
	
	return displayDate;
}
+ (NSString *)relativeTime:(NSDate *)date
{
	NSDate * now = [NSDate date];
	double ti = [date timeIntervalSinceDate:now];
	NSString * suffix;
	NSString * prefix = @"starts in";
	
	if(ti < 1) 
	{
		suffix = @"";
		prefix = @"started";
	} 
	else if (ti <= 60) 
	{
		suffix = @"about a minute";
	}
	else if (ti < 3600) 
	{
		int diff = round(ti / 60);
		
		if(diff == 1)
			suffix = [NSString stringWithFormat:@"about %d minute", diff];
		else 
			suffix =  [NSString stringWithFormat:@"about %d minutes", diff];
	}
	else if (ti < 86400) 
	{
		int diff = round(ti / 60 / 60);
		
		if(diff == 1)
			suffix = [NSString stringWithFormat:@"about %d hour", diff];
		else
			suffix = [NSString stringWithFormat:@"about %d hours", diff];
	}
	else if (ti < 2629743) 
	{
		int diff = round(ti / 60 / 60 / 24);
		
		if(diff == 1)
			suffix = [NSString stringWithFormat:@"about %d day", diff];
		else
			suffix = [NSString stringWithFormat:@"about %d days", diff];
	}
	else 
	{
		suffix = @"you got lots of time";
		prefix = @"";
	}
	
	return [NSString stringWithFormat:@"%@ %@", prefix, suffix];
}
/*- (NSString *)dateDiff:(NSString *)origDate 
 {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setFormatterBehavior:NSDateFormatterBehavior10_4];
	[df setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];
	NSDate *convertedDate = [df dateFromString:origDate];
	[df release];
	 
	NSDate *todayDate = [NSDate date];
	double ti = [convertedDate timeIntervalSinceDate:todayDate];
	ti = ti * -1;
	
	if(ti < 1) 
	{
		return @"never";
	} 
	else if (ti < 60) 
	{
		return @"less than a minute ago";
	} 
	else if (ti < 3600) 
	{
		int diff = round(ti / 60);
		return [NSString stringWithFormat:@"%d minutes ago", diff];
	} 
	else if (ti < 86400) 
	{
		int diff = round(ti / 60 / 60);
		return[NSString stringWithFormat:@"%d hours ago", diff];
	} 
	else if (ti < 2629743) 
	{
		int diff = round(ti / 60 / 60 / 24);
		return[NSString stringWithFormat:@"%d days ago", diff];
	} 
	else 
	{
		return @"never";
	}   
 }
 */
@end








