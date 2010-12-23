//
//  GMRFilter.h
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRTypes.h"

@class GMRGame;
@interface GMRFilter : NSObject {
	GMRTimeInterval timeInterval;
	GMRPlatform platform;
	GMRGame * game;
}
@property(nonatomic, assign) GMRTimeInterval timeInterval;
@property(nonatomic, assign) GMRPlatform platform;
@property(nonatomic, retain) GMRGame * game;

@end
