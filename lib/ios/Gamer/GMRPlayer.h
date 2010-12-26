//
//  GMRPlayer.h
//  Gamer
//
//  Created by Adam Venturella on 12/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMRPlayer : NSObject {
	NSString * alias;
	NSString * username;
}

@property(nonatomic, copy) NSString * alias;
@property(nonatomic, copy) NSString * username;

+ (GMRPlayer *)playerWithDicitonary:(NSDictionary *)dictionary;

@end
