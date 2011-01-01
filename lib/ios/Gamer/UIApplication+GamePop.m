//
//  UIApplicationDelegate+GamePop.m
//  Gamer
//
//  Created by Adam Venturella on 12/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIApplication+GamePop.h"
#import "HazGame.h"
#import "GMRActivityView.h"

static GMRActivityView * activityView;

@implementation UIApplication(GamePop)

- (void)setNetworkActivityIndicatorVisible:(BOOL)value
{
	if(value)
	{
		if(!activityView)
		{
			activityView = [[GMRActivityView alloc] initWithFrame:CGRectZero];
			
			HazGame * app = (HazGame*)[[UIApplication sharedApplication] delegate];
			[app.window addSubview:activityView];
			[activityView release];
		}
			
		
		[activityView transitionIn];
	}
	else 
	{
		if(activityView)
		{
			[activityView transitionOut:^{
				[activityView removeFromSuperview];
				activityView = nil;
				
			}];
			
		}
		
	}

}
@end
