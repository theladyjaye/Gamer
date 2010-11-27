//
//  GMRGame.h
//  Gamer
//
//  Created by Adam Venturella on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRTypes.h"

@interface GMRGame : NSObject {
	NSString * id;
	NSString * label;
	NSArray  * modes;
	NSInteger maxPlayers;
	NSInteger selectedMode;
	GMRPlatform platform;
	
	
}
@property(nonatomic, retain) NSString * id;
@property(nonatomic, retain) NSString * label;
@property(nonatomic, retain) NSArray  * modes;
@property(nonatomic, assign) NSInteger maxPlayers;
@property(nonatomic, assign) NSInteger selectedMode;
@property(nonatomic, assign) GMRPlatform platform;

+ (id)gameWithDicitonary:(NSDictionary *)dictionary;
@end
