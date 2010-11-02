//
//  GMRRequest.h
//  Gamer
//
//  Created by Adam Venturella on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRTypes.h"

@interface GMRRequest : NSObject 
{
	NSString * key;
}
@property(nonatomic, copy) NSString * key;

- (void)execute:(NSDictionary *)options withCallback:(GMRCallback)callback;
@end
