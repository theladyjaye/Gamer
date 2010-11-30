//
//  UIButton+GMRButtonTypes.m
//  Gamer
//
//  Created by Adam Venturella on 11/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIButton+GMRButtonTypes.h"


@implementation UIButton(GMRButtonTypes)

+(UIButton *)buttonWithGMRButtonType:(GMRButtonType)buttonType
{
	UIButton * button;
	NSString * imagePath;
	CGRect rect;
	
	switch (buttonType) 
	{
		case GMRButtonTypeAdd:
			imagePath = [[NSBundle mainBundle] pathForResource:@"ButtonAdd" ofType:@"png"];
			rect = CGRectMake(0, 0, 34, 30);
			break;
			
		case GMRButtonTypeBack:
			imagePath = [[NSBundle mainBundle] pathForResource:@"ButtonBack" ofType:@"png"];
			rect = CGRectMake(0, 0, 57, 30);
			break;
			
		case GMRButtonTypeCancel:
			imagePath = [[NSBundle mainBundle] pathForResource:@"ButtonCancel" ofType:@"png"];
			rect = CGRectMake(0, 0, 70, 30);
			break;
		
		case GMRButtonTypeCreate:
			imagePath = [[NSBundle mainBundle] pathForResource:@"ButtonCreate" ofType:@"png"];
			rect = CGRectMake(0, 0, 68, 30);
			break;
			
		case GMRButtonTypeJoin:
			//imagePath = [[NSBundle mainBundle] pathForResource:@"ButtonNewAccount" ofType:@"png"];
			//rect = CGRectMake(0, 0, 111, 30);
			break;
			
		case GMRButtonTypeLeave:
			//imagePath = [[NSBundle mainBundle] pathForResource:@"ButtonNewAccount" ofType:@"png"];
			//rect = CGRectMake(0, 0, 111, 30);
			break;
		
		case GMRButtonTypeLogin:
			imagePath = [[NSBundle mainBundle] pathForResource:@"ButtonLogin" ofType:@"png"];
			rect = CGRectMake(0, 0, 60, 30);
			break;
			
		case GMRButtonTypeNewAccount:
			imagePath = [[NSBundle mainBundle] pathForResource:@"ButtonNewAccount" ofType:@"png"];
			rect = CGRectMake(0, 0, 111, 30);
			break;
			
		case GMRButtonTypeSave:
			//imagePath = [[NSBundle mainBundle] pathForResource:@"ButtonNewAccount" ofType:@"png"];
			//rect = CGRectMake(0, 0, 111, 30);
			break;
			
		case GMRButtonTypeShare:
			imagePath = [[NSBundle mainBundle] pathForResource:@"ButtonShare" ofType:@"png"];
			rect = CGRectMake(0, 0, 64, 30);
			break;			
	}
	
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = rect;
	
	[button setImage:[UIImage imageWithContentsOfFile:imagePath] 
			forState:UIControlStateNormal];
	
	return button;
}
@end
