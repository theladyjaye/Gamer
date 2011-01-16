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
#import "GMRAlertView.h"

#import "GMRHashing.h"
#import <EventKit/EventKit.h>




@implementation GMRMatch
@synthesize platform, game, availability, scheduled_time, label, maxPlayers, mode, created_by, id, publicUrl, event;

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

- (BOOL)addToDefaultCalendar
{
	BOOL ok         = NO;
	NSError * error = nil;
	
	
	if(self.event != nil)
	{
		GMRAlertView * alert = [[GMRAlertView alloc] initWithStyle:GMRAlertViewStyleNotification 
															 title:@"Already in Calendar" 
														   message:@"This game is already scheduled in your calendar" 
														  callback:^(GMRAlertView *alertView) {
															  [alertView release];
														  }];
		
		[alert show];
	}
	else 
	{
		EKEventStore * eventStore = [[EKEventStore alloc] init];
		EKEvent * newEvent        = [EKEvent eventWithEventStore:eventStore];
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		if([defaults boolForKey:@"alarms_enabled"])
		{
			NSTimeInterval alarmTime  = ([defaults doubleForKey:@"alarm_offset"] * 60.0);
		
			// the scheduled time is less than the users alarm_offset, find the next best time
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
				[newEvent addAlarm:alarm];
			}
		}
		
		newEvent.calendar            = eventStore.defaultCalendarForNewEvents;
		
		newEvent.endDate             = [self.scheduled_time dateByAddingTimeInterval:1800]; // 30 minutes;
		newEvent.location            = [GMRClient formalDisplayNameForPlatform:self.platform];
		newEvent.notes               = self.label;
		newEvent.startDate           = self.scheduled_time;
		newEvent.title               = self.game.label;
		
		if(newEvent.availability != EKEventAvailabilityNotSupported)
			newEvent.availability = EKEventAvailabilityBusy;
		
		
		ok = [eventStore saveEvent:newEvent span:EKSpanThisEvent error:&error];
		
		[eventStore release];
	}
	
	return ok;
}

- (EKEvent *)event
{
	EKEvent * targetEvent     = nil;
	EKEventStore * eventStore = [[EKEventStore alloc] init];
	NSArray * calendars       = [NSArray arrayWithObject:eventStore.defaultCalendarForNewEvents];
	
	NSPredicate * query = [eventStore predicateForEventsWithStartDate:self.scheduled_time 
															  endDate:[self.scheduled_time dateByAddingTimeInterval:86400] // 1 day in the future in case the user changed it's end time
															calendars:calendars];
	
	NSArray * events              = [eventStore eventsMatchingPredicate:query];
	
	//NSLog(@"Events: %@", events);
	
	GMRCalendarIdentifierData current = {.location  = [GMRClient formalDisplayNameForPlatform:self.platform], 
		                                 .title     = self.game.label, 
		                                 .startDate = [self.scheduled_time timeIntervalSince1970]};
	
	NSString * currentDigest = [self calenderIdentifierWithData:current];
	
	for(EKEvent * selectedEvent in events)
	{
		GMRCalendarIdentifierData selected = {.location  = selectedEvent.location,
			.title     = selectedEvent.title,
			.startDate = [[selectedEvent startDate] timeIntervalSince1970]};
		
		NSString * selectedDigest = [self calenderIdentifierWithData:selected];
		
		if([selectedDigest isEqualToString:currentDigest])
		{
			targetEvent = selectedEvent;
			break;
		}
	}
	
	[eventStore release];
	
	return targetEvent;
}

- (BOOL)removeFromDefaultCalendar
{
	EKEventStore * eventStore = [[EKEventStore alloc] init];
	EKEvent * targetEvent = self.event;
	BOOL ok = NO;
	
	/*NSArray * calendars  = [NSArray arrayWithObject:eventStore.defaultCalendarForNewEvents];
	
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
	}*/
	
	if(targetEvent != nil)
	{
		NSError * error = nil;
		 ok = [eventStore removeEvent:targetEvent span:EKSpanThisEvent error:&error];
	}
	
	[eventStore release];
	
	return ok;
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
