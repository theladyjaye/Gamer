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
	GMRButtonTypeAdd,
	GMRButtonTypeBack,
	GMRButtonTypeCancel,
	GMRButtonTypeCreate,
	GMRButtonTypeDone,
	GMRButtonTypeJoin,
	GMRButtonTypeLeave,
	GMRButtonTypeLogin,
	GMRButtonTypeNewAccount,
	GMRButtonTypeSave,
	GMRButtonTypeSend,
	GMRButtonTypeShare
};
typedef NSUInteger GMRButtonType;

@interface UIButton(GMRButtonTypes)
+(UIButton *)buttonWithGMRButtonType:(GMRButtonType)buttonType;
@end
