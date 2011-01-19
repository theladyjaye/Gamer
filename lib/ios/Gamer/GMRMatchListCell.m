//
//  GMRMatchListCell.m
//  Gamer
//
//  Created by Adam Venturella on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRMatchListCell.h"
#import "GMRTypes.h"
#import "NSDate+JSON.h"

@implementation GMRMatchListCell
@synthesize labelString, gameString, dateString, platform, platformString, platformColors, scheduled_time;

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat  grayColor     = 136.0/255;
	
	UIImage * backgroundImage;
	UIFont * gameFont      = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
	UIFont * matchFont     = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
	UIFont * timeFont      = [UIFont fontWithName:@"HelveticaNeue-Italic" size:10.0];
	UIFont * platformFont  = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
	UIColor * fontColor    = [UIColor colorWithRed:grayColor
											 green:grayColor
											  blue:grayColor
											 alpha:1.0];
	
	self.dateString = [NSDate relativeTime:self.scheduled_time];
	
	switch (platform) 
	{
		case GMRPlatformBattleNet:
			platformString   = @"bnet";
			platformColors = [UIImage imageNamed:@"PlatformColorHorizontalBattleNet.png"];
			break;
			
		case GMRPlatformPlaystation2:
			platformString   = @"ps2";
			platformColors = [UIImage imageNamed:@"PlatformColorHorizontalPlaystation2.png"];
			break;
			
		case GMRPlatformPlaystation3:
			platformString   = @"ps3";
			platformColors = [UIImage imageNamed:@"PlatformColorHorizontalPlaystation3.png"];
			break;
			
		case GMRPlatformSteam:
			platformString   = @"stm";
			platformColors = [UIImage imageNamed:@"PlatformColorHorizontalSteam.png"];
			break;
			
		case GMRPlatformWii:
			platformString   = @"wii";
			platformColors = [UIImage imageNamed:@"PlatformColorHorizontalWii.png"];
			break;
			
		case GMRPlatformXBox360:
			platformString   = @"xbox";
			platformColors = [UIImage imageNamed:@"PlatformColorHorizontalXbox360.png"];
			break;
			
		default:
			platformString = @"unkn";
			break;
	}
	
	[[UIColor whiteColor] set];
	CGContextFillRect(context, rect);
	
	if(highlighted)
		backgroundImage = [UIImage imageNamed:@"BackgroundMatchCellSelected.png"];
	else
		backgroundImage = [UIImage imageNamed:@"BackgroundMatchCell.png"];
		
	
	[backgroundImage drawAtPoint:CGPointMake(0, 0)];
	
	[fontColor set];
	[gameString drawAtPoint:CGPointMake(38.0, 10.0)  withFont:gameFont];
	
	//[labelString drawAtPoint:CGPointMake(38.0, 26.0) withFont:matchFont];
	
	[labelString drawInRect:CGRectMake(38.0, 26.0, 240.0, 14.0) 
			          withFont:matchFont 
		         lineBreakMode:UILineBreakModeTailTruncation 
			         alignment:UITextAlignmentLeft];
	
	
	[dateString drawAtPoint:CGPointMake(38.0, 40.0)  withFont:timeFont];
	
	[platformColors drawAtPoint:CGPointMake(286, 54)];
	
    [platformString drawInRect:CGRectMake(286.0, 41.0, 34.0, 14.0) 
			          withFont:platformFont 
		         lineBreakMode:UILineBreakModeClip 
			         alignment:UITextAlignmentCenter];

}

- (void)dealloc
{
	self.labelString    = nil;
	self.gameString     = nil;
	self.dateString     = nil;
	self.platformString = nil;
	//self.platformColors = nil;
	self.scheduled_time = nil;
	[super dealloc];
}

@end
