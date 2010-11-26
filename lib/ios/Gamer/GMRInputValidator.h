//
//  GMRInputValidator.h
//  Gamer
//
//  Created by Adam Venturella on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRValidator.h"

@interface GMRInputValidator : GMRValidator {
	NSInteger minLength;
	NSInteger maxLength;
}

+ (id)validatorWithKeyPath:(NSString *)path requirement:(GMRValidatorRequirement)req minLength:(NSInteger)min maxLength:(NSInteger)max message:(NSString *)msg;

@property(nonatomic, assign)NSInteger minLength;
@property(nonatomic, assign)NSInteger maxLength;

@end
