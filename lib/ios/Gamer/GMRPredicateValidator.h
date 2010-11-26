//
//  GMRPredicateValidator.h
//  Gamer
//
//  Created by Adam Venturella on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRValidator.h"

@interface GMRPredicateValidator : GMRValidator {
	NSPredicate * predicate;
}

+ (id)validatorWithPredicate:(NSPredicate *)predicate requirement:(GMRValidatorRequirement)req message:(NSString *)msg;
@property(nonatomic, retain) NSPredicate * predicate;

@end
