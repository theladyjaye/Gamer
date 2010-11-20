//
//  GMRButton.h
//  Gamer
//
//  Created by Adam Venturella on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum  {
	GMRButtonStyleTeal,
	GMRButtonStyleRed,
	GMRButtonStyleGray,
	GMRButtonStyleYellow
};
typedef NSUInteger GMRButtonStyle;

@interface GMRButton : UIButton {

}

- (id)initWithStyle:(GMRButtonStyle)style label:(NSString *)label target:(NSObject *)target action:(SEL)action;
@end
