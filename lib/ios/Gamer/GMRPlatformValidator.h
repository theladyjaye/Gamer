//
//  GMRPlatformValidator.h
//  Gamer
//
//  Created by Adam Venturella on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRValidator.h"

@interface GMRPlatformValidator : GMRValidator 
+ (id)validatorWithKeyPath:(NSString *)kvcKey requirement:(GMRValidatorRequirement)req message:(NSString *)msg;
@end
