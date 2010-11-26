//
//  GMRRequiredValidator.m
//  Gamer
//
//  Created by Adam Venturella on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRNotNilValidator.h"
#import "GMRForm.h"

@implementation GMRNotNilValidator

+ (id)validatorWithKeyPath:(NSString *)kvcKey requirement:(GMRValidatorRequirement)req message:(NSString *)msg
{
	GMRNotNilValidator * obj = [[GMRNotNilValidator alloc] init];
	obj.key         = kvcKey;
	obj.message     = msg;
	obj.requirement = req;
	
	return [obj autorelease];
}

- (void)validate
{
	id value = [self.form.context valueForKeyPath:self.key];
	
	if(value != nil)
	{
		_ok = YES;
		return;
	}
	
	_ok = NO;
}
@end
