//
//  GMRMatchListCell.m
//  Gamer
//
//  Created by Adam Venturella on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRMatchListCell.h"
#import "GMRTypes.h"

static UIImage* background;
static UIImage* backgroundSelected;

@implementation GMRMatchListCell
@synthesize labelString, gameString, dateString, platform, platformString, platformColors;

+(void)initialize
{
	background         = [UIImage imageNamed:@"BackgroundMatchCell.png"];
	backgroundSelected = [UIImage imageNamed:@"BackgroundMatchCellSelected.png"];
}

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIFont * gameFont      = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
	UIFont * matchFont     = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
	UIFont * timeFont      = [UIFont fontWithName:@"HelveticaNeue-Italic" size:10.0];
	UIFont * platformFont  = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
	UIColor * fontColor    = [UIColor colorWithRed:136.0/255.0 
											 green:136.0/255.0 
											  blue:136.0/255.0 
											 alpha:1.0];
	
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
		[backgroundSelected drawAtPoint:CGPointMake(0, 0)];
	else
		[background drawAtPoint:CGPointMake(0, 0)];
	
	[fontColor set];
	[gameString drawAtPoint:CGPointMake(38.0, 10.0)  withFont:gameFont];
	[labelString drawAtPoint:CGPointMake(38.0, 26.0) withFont:matchFont];
	[dateString drawAtPoint:CGPointMake(38.0, 40.0)  withFont:timeFont];
	
	[platformColors drawAtPoint:CGPointMake(286, 55)];
	
    [platformString drawInRect:CGRectMake(286.0, 41.0, 34.0, 14.0) 
			          withFont:platformFont 
		         lineBreakMode:UILineBreakModeClip 
			         alignment:UITextAlignmentCenter];

}
/*
- (void)setPlatform:(GMRPlatform)value
{
	platform = value;
	
	switch (platform) 
	{
		case GMRPlatformBattleNet:
			platformLabel.text   = @"bnet";
			platformColors.image = [UIImage imageNamed:@"PlatformColorHorizontalBattleNet.png"];
			break;
			
		case GMRPlatformPlaystation2:
			platformLabel.text   = @"ps2";
			platformColors.image = [UIImage imageNamed:@"PlatformColorHorizontalPlaystation2.png"];
			break;
			
		case GMRPlatformPlaystation3:
			platformLabel.text   = @"ps3";
			platformColors.image = [UIImage imageNamed:@"PlatformColorHorizontalPlaystation3.png"];
			break;
		
		case GMRPlatformSteam:
			platformLabel.text   = @"stm";
			platformColors.image = [UIImage imageNamed:@"PlatformColorHorizontalSteam.png"];
			break;
			
		case GMRPlatformWii:
			platformLabel.text   = @"wii";
			platformColors.image = [UIImage imageNamed:@"PlatformColorHorizontalWii.png"];
			break;
			
		case GMRPlatformXBox360:
			platformLabel.text   = @"xbox";
			platformColors.image = [UIImage imageNamed:@"PlatformColorHorizontalXbox360.png"];
			break;
			
		default:
			platformLabel.text = @"unkn";
			break;
	}
}

*/
- (void)dealloc
{
	self.labelString    = nil;
	self.gameString     = nil;
	self.dateString     = nil;
	self.platformString = nil;
	self.platformColors = nil;
	[super dealloc];
}

@end
