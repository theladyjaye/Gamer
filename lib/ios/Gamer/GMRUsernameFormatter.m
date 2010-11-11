//
//  GMRUsernameFormatter.m
//  Gamer
//
//  Created by Adam Venturella on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRUsernameFormatter.h"

static NSString * kCharacters = @"abcdefghijklmnopqrstuvwxyz1234567890_";
@implementation GMRUsernameFormatter

- (NSString *)stringForObjectValue:(id)anObject
{
    NSString * result;
	
	if (anObject == nil ) 
	{
		result =  nil;
	} 
	else 
	{        
		result = [self applyFormat:anObject withValidCharacters:kCharacters];
	}
	
	return [result lowercaseString];
}

@end
