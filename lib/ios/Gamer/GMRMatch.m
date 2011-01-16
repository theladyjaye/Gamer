//
//  GMRGame.m
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRMatch.h"
#import "GMRGame.h"
#import "GMRTypes.h"
#import "GMRClient.h"
#import "GMRUtils.h"
#import "NSDate+JSON.h"

#import "GMRHashing.h"
#import <EventKit/EventKit.h>




@implementation GMRMatch
@synthesize platform, game, availability, scheduled_time, label, maxPlayers, mode, created_by, id, publicUrl;

+ (id)matchWithDicitonary:(NSDictionary *)dictionary
{
	GMRMatch * match        = [[GMRMatch alloc] init];
	match.id                = [dictionary objectForKey:@"_id"];
	match.game              = [GMRGame gameWithDicitonary:[dictionary objectForKey:@"game"]];
	match.platform          = [GMRClient platformForString:[dictionary valueForKeyPath:@"game.platform"]];
	match.created_by        = [dictionary objectForKey:@"created_by"];
	match.mode              = [dictionary objectForKey:@"mode"];
	match.scheduled_time    = [NSDate dateWithJSONString:[dictionary objectForKey:@"scheduled_time"]];
	match.label             = [dictionary objectForKey:@"label"];
	match.maxPlayers        = [[dictionary objectForKey:@"maxPlayers"] intValue];
	match.availability      = [[dictionary objectForKey:@"availability"] isEqualToString:@"public"] ? GMRMatchAvailabliltyPublic : GMRMatchAvailabliltyPrivate; 
	match.game.selectedMode = [match.game.modes indexOfObject:match.mode];
	
	return [match autorelease];
}

- (NSString *)publicUrl
{
	return [NSString stringWithFormat:@"http://gamepopapp.com/%@/%@/%@", [GMRClient stringForPlatform:self.platform], [GMRUtils cleanupGameId:self.game.id], self.id];
	
}

- (void)addToDefaultCalendar
{
	BOOL ok         = NO;
	NSError * error = nil;
	
	EKEventStore * eventStore = [[EKEventStore alloc] init];
	EKEvent * event           = [EKEvent eventWithEventStore:eventStore];
	NSTimeInterval alarmTime  = 900; // 15 minutes
	
	// the scheduled time is less than 15 minutes from now:
	if([self.scheduled_time compare:[NSDate dateWithTimeIntervalSinceNow:alarmTime]] ==  NSOrderedAscending)
	{
		NSComparisonResult test = NSOrderedAscending;
		NSTimeInterval bestAlarmTime = alarmTime;
		while(test == NSOrderedAscending)
		{
			bestAlarmTime = bestAlarmTime - 60; // remove 1 minute until we find the best time.
			test = [self.scheduled_time compare:[NSDate dateWithTimeIntervalSinceNow:bestAlarmTime]];
		}
		
		alarmTime = (bestAlarmTime - 60); // we want it to trigger in 60 seconds
	}
	
	
	if(alarmTime >= 300) // 5 minutes
	{
		EKAlarm * alarm           = [EKAlarm alarmWithRelativeOffset:-alarmTime];
		[event addAlarm:alarm];
	}
	
	event.calendar            = eventStore.defaultCalendarForNewEvents;
	
	event.endDate             = [self.scheduled_time dateByAddingTimeInterval:1800]; // 30 minutes;
	event.location            = [GMRClient formalDisplayNameForPlatform:self.platform];
	event.notes               = self.label;
	event.startDate           = self.scheduled_time;
	event.title               = self.game.label;
	
	if(event.availability != EKEventAvailabilityNotSupported)
		event.availability = EKEventAvailabilityBusy;
	
	
	ok = [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
	
	[eventStore release];
}

- (void)removeFromDefaultCalendar
{
	EKEventStore * eventStore = [[EKEventStore alloc] init];
	EKEvent * targetEvent = nil;
	BOOL ok = NO;
	
	NSArray * calendars  = [NSArray arrayWithObject:eventStore.defaultCalendarForNewEvents];
	
	// The user may have changed their default calender between adding and removing, so we search them all.
	// first we are going to check the default calender.  If it's not there, we will check them all
	NSPredicate * query = [eventStore predicateForEventsWithStartDate:self.scheduled_time 
															  endDate:[self.scheduled_time dateByAddingTimeInterval:86400] // 1 day in the future in case the user changed it's end time
															calendars:calendars];
	
	NSArray * events              = [eventStore eventsMatchingPredicate:query];
	
	
	GMRCalendarIdentifierData current = {.location  = [GMRClient formalDisplayNameForPlatform:self.platform], 
									     .title     = self.game.label, 
									     .startDate = [self.scheduled_time timeIntervalSince1970]};
	
	NSString * currentDigest = [self calenderIdentifierWithData:current];
	
	
	for(EKEvent * event in events)
	{
		GMRCalendarIdentifierData selected = {.location  = event.location,
										      .title     = event.title,
			                                  .startDate = [[event startDate] timeIntervalSince1970]};
		
		NSString * selectedDigest = [self calenderIdentifierWithData:selected];
		
		if([selectedDigest isEqualToString:currentDigest])
		{
			targetEvent = event;
			break;
		}
	}
	
	if(targetEvent != nil)
	{
		NSError * error = nil;
		 ok = [eventStore removeEvent:targetEvent span:EKSpanThisEvent error:&error];
		
		if(ok == NO)
		{
		
		}
	}
	
	[eventStore release];
}

- (NSString *)calenderIdentifierWithData:(GMRCalendarIdentifierData)data
{
	NSString * string = [NSString stringWithFormat:@"%@%f%@", [data.location lowercaseString],
						 data.startDate,
						 [data.title lowercaseString]];
	
	
	return [GMRHashing md5:string];	
}


- (void)dealloc
{
	self.game           = nil;
	self.scheduled_time = nil;
	self.label          = nil;
	self.mode           = nil;
	self.created_by     = nil;
	self.id             = nil;
	
	[super dealloc];
}
@end
