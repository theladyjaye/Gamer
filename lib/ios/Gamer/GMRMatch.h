//
//  GMRGame.h
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRTypes.h"

@class GMRGame;
@interface GMRMatch : NSObject 
{
	GMRGame  * game;
	NSDate * time;
	NSString * description;
	
	GMRPlatform platform;
	GMRMatchAvailablilty availability;
	NSInteger players;	
}
@property(nonatomic, retain) GMRGame * game;
@property(nonatomic, retain) NSDate * time;
@property(nonatomic, retain) NSString * description;
@property(nonatomic, assign) GMRPlatform platform;
@property(nonatomic, assign) GMRMatchAvailablilty availability;
@property(nonatomic, assign) NSInteger players;

@end
