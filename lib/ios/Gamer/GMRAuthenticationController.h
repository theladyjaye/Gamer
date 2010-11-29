//
//  GMRAuthenticationController.h
//  Gamer
//
//  Created by Adam Venturella on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMRAuthenticationInputController, GMRNavigationController;

@interface GMRAuthenticationController : UIViewController 
{
	GMRAuthenticationInputController * inputController;
	UIImageView * defaultImageView;
	GMRNavigationController * gmrNavigationController;
	UIToolbar * toolbar;
}

@property (nonatomic, retain) IBOutlet UIImageView * defaultImageView;
@property (nonatomic, readonly) UIToolbar * toolbar;
@property (nonatomic, assign) GMRNavigationController * gmrNavigationController;
- (void)authenticationDidSucceed;

@end
