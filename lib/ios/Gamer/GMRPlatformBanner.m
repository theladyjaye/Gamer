//
//  GMRPlatformBanner.m
//  Gamer
//
//  Created by Adam Venturella on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRPlatformBanner.h"


@implementation GMRPlatformBanner
@synthesize platform;

- (void)setPlatform:(GMRPlatform)value
{
	if(value != platform)
	{
		platform = value;
		UIImage * platformImage;
		
		switch(platform)
		{
			case GMRPlatformBattleNet:
				platformImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PlatformBattleNet" ofType:@"png"]];
				break;
				
			case GMRPlatformPC:
				platformImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PlatformBattleNet" ofType:@"png"]];
				break;
			
			case GMRPlatformPlaystation2:
				platformImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PlatformPlaystation2" ofType:@"png"]];
				break;
			
			case GMRPlatformPlaystation3:
				platformImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PlatformPlaystation3" ofType:@"png"]];
				break;
			
			case GMRPlatformUnknown:
				platformImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PlatformBattleNet" ofType:@"png"]];
				break;
			
			case GMRPlatformWii:
				platformImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PlatformWii" ofType:@"png"]];
				break;
			
			case GMRPlatformXBox360:
				platformImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PlatformXbox360" ofType:@"png"]];
				break;
		}
		
		self.image = platformImage;
	}
}
@end
