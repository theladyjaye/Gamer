//
//  GMRGame.h
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GMRTypes.h"

typedef struct GMRCalenderIdentifierData
{
	NSString * title;
	NSString * location;
	NSTimeInterval startDate;
} GMRCalendarIdentifierData;


@class GMRGame, EKEvent;
@interface GMRMatch : NSObject 
{
	GMRGame  * game;
	NSString * id;
	NSDate * scheduled_time;
	NSString * label;
	NSString * mode;
	NSString * created_by;
	
	GMRPlatform platform;
	GMRMatchAvailablilty availability;
	NSInteger maxPlayers;
}
@property(nonatomic, retain) GMRGame * game;
@property(nonatomic, retain) NSDate * scheduled_time;
@property(nonatomic, retain) NSString * id;
@property(nonatomic, retain) NSString * label;
@property(nonatomic, retain) NSString * created_by;
@property(nonatomic, retain) NSString * mode;
@property(nonatomic, assign) GMRPlatform platform;
@property(nonatomic, assign) GMRMatchAvailablilty availability;
@property(nonatomic, assign) NSInteger maxPlayers;
@property(nonatomic, readonly) NSString * publicUrl;
@property(nonatomic, readonly) EKEvent * event;

+ (id)matchWithDicitonary:(NSDictionary *)dictionary;

- (BOOL)addToDefaultCalendar;
- (BOOL)removeFromDefaultCalendar;
- (NSString *)calenderIdentifierWithData:(GMRCalendarIdentifierData)data;
@end
