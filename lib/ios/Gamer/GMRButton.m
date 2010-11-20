//
//  GMRButton.m
//  Gamer
//
//  Created by Adam Venturella on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRButton.h"


@implementation GMRButton
- (id)initWithStyle:(GMRButtonStyle)style label:(NSString *)label target:(NSObject *)target action:(SEL)action
{
	
	self = [UIButton buttonWithType:UIButtonTypeCustom];
	
	if(self)
	{
		[self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
		self.frame = CGRectMake(0.0, 0.0, 314.0, 39.0);
		
		
		UILabel * buttonLabel       = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 9.0, (self.frame.size.width - 34.0), 20.0)];
		buttonLabel.font            = [UIFont systemFontOfSize:16.0];
		buttonLabel.textAlignment   = UITextAlignmentCenter;
		buttonLabel.backgroundColor = [UIColor clearColor];
		buttonLabel.textColor       = [UIColor whiteColor];
		buttonLabel.text            = label;
		
		[self addSubview:buttonLabel];
		[buttonLabel release];
		
		UIImage * defaultState;
		UIImage * highlightedState;
		
		switch(style)
		{
			case GMRButtonStyleGray:
				defaultState     = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonGrayFull" ofType:@"png"]];
				highlightedState = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonGrayFullSelected" ofType:@"png"]];
				break;
			
			case GMRButtonStyleRed:
				defaultState     = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonRedFull" ofType:@"png"]];
				highlightedState = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonRedFullSelected" ofType:@"png"]];
				break;
			
			case GMRButtonStyleTeal:
				defaultState     = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonTealFull" ofType:@"png"]];
				highlightedState = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonTealFullSelected" ofType:@"png"]];
				break;
			
			case GMRButtonStyleYellow:
				defaultState     = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonYellowFull" ofType:@"png"]];
				highlightedState = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonellowFullSelected" ofType:@"png"]];
				break;
		}
		
		[self setBackgroundImage:defaultState forState:UIControlStateNormal];
		[self setBackgroundImage:highlightedState forState:UIControlStateHighlighted];
		
		[self retain];
	}
	
	return self;
	
}
@end
