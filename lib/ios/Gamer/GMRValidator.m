//
//  GMRValidator.m
//  Gamer
//
//  Created by Adam Venturella on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRValidator.h"
#import "GMRForm.h"

@implementation GMRValidator
@synthesize form, key, message, requirement, ok=_ok;

- (void)validate
{
	_ok = YES;
}

- (void)dealloc
{
	self.key = nil;
	self.message = nil;
	[super dealloc];
}
@end
