//
//  GMRInputValidator.m
//  Gamer
//
//  Created by Adam Venturella on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRInputValidator.h"
#import "GMRForm.h"

@implementation GMRInputValidator
@synthesize minLength, maxLength;

+ (id)validatorWithKeyPath:(NSString *)path requirement:(GMRValidatorRequirement)req minLength:(NSInteger)min maxLength:(NSInteger)max message:(NSString *)msg
{
	GMRInputValidator * obj = [[GMRInputValidator alloc] init];
	obj.key = path;
	obj.requirement = req;
	obj.minLength = min;
	obj.maxLength = max;
	obj.message = msg;
	
	return [obj autorelease];
}

- (void)validate
{
	NSString * value = (NSString *)[self.form.context valueForKeyPath:self.key];
	
	if(self.minLength > 0)
	{
		if([value length] < self.minLength)
		{
			_ok = NO;
			return;
		}
		else
		{
			_ok = YES;
		}
	}
	
	if(self.maxLength > 0)
	{
		if([value length] <= self.maxLength)
		{
			_ok = YES;
		}
		else
		{
			_ok = NO;
		}
	}
}

@end
