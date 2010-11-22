//
//  GMRGame.h
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRTypes.h"

@interface GMRMatch : NSObject 
{
	GMRPlatform platform;
	NSString * gameId;
	NSString * gameTitle;
	NSString * gameMode;
	NSString * availability;
	NSInteger players;
	NSString * time;
	NSString * description;
	
}
@property(nonatomic) GMRPlatform platform;
@property(nonatomic, retain) NSString * gameId;
@property(nonatomic, retain) NSString * gameTitle;
@property(nonatomic, retain) NSString * gameMode;
@property(nonatomic, retain) NSString * availability;
@property(nonatomic, assign) NSInteger players;
@property(nonatomic, retain) NSString * time;
@property(nonatomic, retain) NSString * description;
@end
