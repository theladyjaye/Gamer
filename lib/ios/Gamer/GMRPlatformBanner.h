//
//  GMRPlatformBanner.h
//  Gamer
//
//  Created by Adam Venturella on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRTypes.h"

@interface GMRPlatformBanner : UIImageView {
	GMRPlatform platform;
}
@property (nonatomic, assign) GMRPlatform platform;

@end
