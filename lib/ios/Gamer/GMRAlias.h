//
//  GMRAlias.h
//  Gamer
//
//  Created by Adam Venturella on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRTypes.h"

@interface GMRAlias : NSObject {
	GMRPlatform platform;
	NSString * alias;
}

@property (nonatomic, assign) GMRPlatform platform;
@property (nonatomic, retain) NSString * alias;
@end
