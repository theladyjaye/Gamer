//
//  HazGame.h
//  Gamer
//
//  Created by Adam Venturella on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMRAuthenticationController, GMRMainController,GMRNavigationController;
@interface HazGame : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	GMRNavigationController * authenticationController;
	GMRMainController * mainController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (BOOL)hasAuthenticatedUser;
- (void)initializeAuthenticationFlow;
- (void)initializeApplicationFlow;

@end
