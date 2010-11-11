//
//  GMRFormatter.m
//  Gamer
//
//  Created by Adam Venturella on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRFormatter.h"


@implementation GMRFormatter
@synthesize onInvalidCharacter;

-(NSString *) applyFormat:(NSString *)string withValidCharacters:(NSString *)validCharacters
{
	NSCharacterSet *unacceptedInput =[[NSCharacterSet characterSetWithCharactersInString:validCharacters] invertedSet];
	
	NSString  * result;
	result = [string stringByTrimmingCharactersInSet:unacceptedInput];
	
	if([result length] == 0)
	{
		if(self.onInvalidCharacter) self.onInvalidCharacter();
		result = nil;
	}
	
	return result;
}

-(NSString *) applyFormat:(NSString *)string withInvalidCharacters:(NSString *)invalidCharacters
{
	NSCharacterSet *unacceptedInput =[NSCharacterSet characterSetWithCharactersInString:invalidCharacters];
	
	NSString  * result;
	result = [string stringByTrimmingCharactersInSet:unacceptedInput];
	
	if([result length] == 0)
	{
		if(self.onInvalidCharacter) self.onInvalidCharacter();
		result = nil;
	}
	
	return result;
}

- (void)dealloc
{
	self.onInvalidCharacter = nil;
	[super dealloc];
}

@end
