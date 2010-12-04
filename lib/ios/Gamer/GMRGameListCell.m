//
//  GMRGameListCell.m
//  Gamer
//
//  Created by Adam Venturella on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRGameListCell.h"


@implementation GMRGameListCell
@synthesize title;

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat  grayColor     = 136.0/255;
	
	UIImage * backgroundImage = [UIImage imageNamed:@"BackgroundGameCell.png"];
	
	UIFont * playerFont    = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
	UIColor * fontColor    = [UIColor colorWithRed:grayColor
											 green:grayColor
											  blue:grayColor
											 alpha:1.0];
	
	[[UIColor whiteColor] set];
	CGContextFillRect(context, rect);
	
	[backgroundImage drawAtPoint:CGPointMake(0, 0)];
	
	CGFloat fontHeight = playerFont.pointSize;
    CGFloat yOffset    = (rect.size.height - fontHeight) / 2.0;
	
    CGRect textRect = CGRectMake(10.0, yOffset-4.0, rect.size.width-10.0, fontHeight);
	
	CGContextSetFillColorWithColor(context, fontColor.CGColor);
    [title drawInRect:textRect 
			  withFont:playerFont 
		 lineBreakMode:UILineBreakModeClip 
			 alignment:UITextAlignmentLeft];
	
}


- (void)dealloc 
{
    self.title = nil;
	[super dealloc];
}


@end
