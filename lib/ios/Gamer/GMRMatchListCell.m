//
//  GMRMatchListCell.m
//  Gamer
//
//  Created by Adam Venturella on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRMatchListCell.h"
#import "GMRTypes.h"

@implementation GMRMatchListCell
@synthesize label, game, date, platform, platformLabel, platformColors;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state.
}

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


- (void)dealloc
{
	self.label = nil;
	self.game = nil;
	self.date = nil;
	self.platformLabel = nil;
	self.platformColors = nil;
	[super dealloc];
}

@end
