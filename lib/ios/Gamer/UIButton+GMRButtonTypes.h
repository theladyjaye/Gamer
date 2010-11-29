//
//  UIButton+GMRButtonTypes.h
//  Gamer
//
//  Created by Adam Venturella on 11/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum
{
	GMRButtonTypeBack,
	GMRButtonTypeCancel,
	GMRButtonTypeCreate,
	GMRButtonTypeJoin,
	GMRButtonTypeLeave,
	GMRButtonTypeLogin,
	GMRButtonTypeNewAccount,
	GMRButtonTypeSave,
	GMRButtonTypeShare
};
typedef NSUInteger GMRButtonType;

@interface UIButton(GMRButtonTypes)
+(UIButton *)buttonWithGMRButtonType:(GMRButtonType)buttonType;
@end
