//
//  GMRFormValidator.m
//  Gamer
//
//  Created by Adam Venturella on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRForm.h"
#import "GMRValidator.h"

@implementation GMRForm
@synthesize errors, context;
@dynamic ok;

- (id)initWithContext:(id)ctx;
{
	self = [super init];
	
	if(self)
	{
		_ok = YES;
		
		[ctx retain];
		context = ctx;
		
		validators = [NSMutableArray array];
		[validators retain];
	}
	
	return self;
}

- (void)addValidator:(GMRValidator *)validator
{
	needsValidation = YES;
	validator.form  = self;
	[validators addObject: validator];
}

- (void)validate
{
	BOOL tempFlag;
	for(GMRValidator * validator in validators)
	{
		[validator validate];
		
		if(validator.requirement == GMRValidatorRequirementRequired)
			tempFlag = (tempFlag && validator.ok);
	}
	
	if(tempFlag != _ok)
		_ok = tempFlag;
	
	if(_ok == NO)
		[self hydrateErrorMessages];
	
}

- (void)hydrateErrorMessages
{
	if(errors)
	{
		[errors release];
		errors = nil;
	}
	
	errors = [NSMutableArray array];
	for(GMRValidator * validator in validators)
	{
		if(validator.ok == NO)
		{
			[errors addObject:validator.message];
		}
	}
}

- (BOOL)ok
{
	if(needsValidation)
	{
		if([validators count] > 0)
		{
			[self validate];
		}
		else
		{
			_ok = YES;
		}
		
		needsValidation = NO;
	}
	
	return _ok;
}

- (void)dealloc
{
	[context release];
	[validators release];
	[errors release];
	
	[super dealloc];
}
@end
