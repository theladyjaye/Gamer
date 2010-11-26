//
//  GMRPredicateValidator.m
//  Gamer
//
//  Created by Adam Venturella on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRPredicateValidator.h"
#import "GMRForm.h"

@implementation GMRPredicateValidator
@synthesize predicate;

+ (id)validatorWithPredicate:(NSPredicate *)predicate requirement:(GMRValidatorRequirement)req message:(NSString *)msg
{
	GMRPredicateValidator * obj = [[GMRPredicateValidator alloc] init];
	obj.requirement = req;
	obj.message = msg;
	obj.predicate = predicate;
	return [obj autorelease];
}

- (void)validate
{
	_ok =[self.predicate evaluateWithObject:self.form.context];
}

- (void)dealloc
{
	self.predicate = nil;
	[super dealloc];
}
@end
