//
//  GMRAliasListCell.m
//  Gamer
//
//  Created by Adam Venturella on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRAliasListCell.h"


@implementation GMRAliasListCell
@synthesize alias, platform;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted 
{	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIImage * backgroundImage = [UIImage imageNamed:@"BackgroundAliasCell.png"];
	
	/*if(highlighted)
	{
		UIImage * checkboxImage  = [UIImage imageNamed:@"ButtonPodCheckbox.png"];
		CGFloat x = (backgroundImage.size.width - checkboxImage.size.width) - 1;
		[checkboxImage drawAtPoint:CGPointMake( x ,1)];
	}
	else 
	{*/
	
	
	//[[UIColor clearColor] set];
	//CGContextFillRect(context, rect);
	
	NSString * platformString;
	UIImage * platformColors;
	CGFloat  grayColor     = 136.0/255.0;
	UIFont * playerFont    = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
	UIFont * platformFont  = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
	UIColor * fontColor    = [UIColor colorWithRed:grayColor
											 green:grayColor
											  blue:grayColor
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
	
	
	[backgroundImage drawAtPoint:CGPointMake(0, 0)];
	[platformColors drawAtPoint:CGPointMake(286.0, 29.0)];
	
	CGFloat fontHeight = playerFont.pointSize;
	CGFloat yOffset    = (rect.size.height - fontHeight) / 2.0;
	
	CGRect textRect = CGRectMake(10.0, yOffset-3.0, rect.size.width-10.0, fontHeight);
	
	CGContextSetFillColorWithColor(context, fontColor.CGColor);
	
	[platformString drawInRect:CGRectMake(286.0, 16.0, 34.0, 14.0) 
			          withFont:platformFont 
		         lineBreakMode:UILineBreakModeClip 
			         alignment:UITextAlignmentCenter];
	
	[alias drawInRect:textRect 
			 withFont:playerFont 
		lineBreakMode:UILineBreakModeClip 
			alignment:UITextAlignmentCenter];
	/*}*/
	
}


- (void)dealloc {
    [super dealloc];
}


@end
