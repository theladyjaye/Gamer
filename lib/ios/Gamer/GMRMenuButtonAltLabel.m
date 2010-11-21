//
//  GMRMenuButtonAltText.m
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRMenuButtonAltLabel.h"


@implementation GMRMenuButtonAltLabel
@synthesize altLabel;

- (UIImage *)backgroundImageForOpenNormal
{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonInputOpenLarge" ofType:@"png"]];
}

- (UIImage *)backgroundImageForClosedNormal
{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonInputClosedLarge" ofType:@"png"]];
}

- (UIImage *)backgroundImageForSelected
{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonInputLargeSelected" ofType:@"png"]];
}

- (void)dealloc 
{
    self.altLabel = nil;
	[super dealloc];
}


@end
