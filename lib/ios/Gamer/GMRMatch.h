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
	GMRPlatform platform;
	GMRGame  * game;
	NSString * availability;
	NSInteger players;
	NSString * time;
	NSString * description;
	
}
@property(nonatomic) GMRPlatform platform;
@property(nonatomic, retain) GMRGame * game;
@property(nonatomic, retain) NSString * availability;
@property(nonatomic, assign) NSInteger players;
@property(nonatomic, retain) NSString * time;
@property(nonatomic, retain) NSString * description;
@end
