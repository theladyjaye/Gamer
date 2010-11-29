//
//  GMRLabel.m
//  Gamer
//
//  Created by Adam Venturella on 11/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRLabel.h"


@implementation GMRLabel
+ (id)titleLabelWithString:(NSString *)value
{
	GMRLabel * label      = [[GMRLabel alloc] initWithFrame:CGRectZero];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment   = UITextAlignmentCenter;
	label.textColor       = [UIColor whiteColor];
	label.shadowColor     = [UIColor blackColor];
	label.shadowOffset    = CGSizeMake(0, 1);
	label.font            = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
	label.text            = value;
	[label sizeToFit];
	
	return [label autorelease];
	
}
@end
