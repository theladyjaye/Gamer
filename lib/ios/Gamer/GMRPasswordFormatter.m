//
//  GMRPasswordFormatter.m
//  Gamer
//
//  Created by Adam Venturella on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRPasswordFormatter.h"

static NSString * kCharacters = @"\n\"'`\\/ ";
@implementation GMRPasswordFormatter
- (NSString *)stringForObjectValue:(id)anObject
{
    NSString * result;
	
	if (anObject == nil ) 
	{
		result =  nil;
	} 
	else 
	{        
		result = [self applyFormat:anObject withInvalidCharacters:kCharacters];
	}
	
	return [result lowercaseString];
}
@end
