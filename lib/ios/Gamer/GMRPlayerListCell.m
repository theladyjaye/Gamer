//
//  GMRPlayerListCell.m
//  Gamer
//
//  Created by Adam Venturella on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRPlayerListCell.h"


@implementation GMRPlayerListCell
@synthesize player;

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat  grayColor     = 136.0/255;
	
	UIImage * backgroundImage = [UIImage imageNamed:@"BackgroundPlayerCell.png"];
	
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
	
    CGRect textRect = CGRectMake(0, yOffset-4.0, rect.size.width, fontHeight);
	
	CGContextSetFillColorWithColor(context, fontColor.CGColor);
    [player drawInRect:textRect 
			  withFont:playerFont 
		 lineBreakMode:UILineBreakModeClip 
			 alignment:UITextAlignmentCenter];
	
	//[fontColor set];
	//[playerFont drawAtPoint:CGPointMake(38.0, 10.0)  withFont:gameFont];

}

- (void)dealloc {
	self.player = nil;
    [super dealloc];
}


@end
