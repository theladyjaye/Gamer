//
//  GMRUtils.h
//  Gamer
//
//  Created by Adam Venturella on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMRUtils : NSObject {

}

+ (NSString *)cleanupGameId:(NSString *)gameId;
+ (NSString *)formEncodedStringFromDictionary:(NSDictionary *)dictionary;
+ (NSString *)formEncodedStringFromString:(NSString *)value;


@end
