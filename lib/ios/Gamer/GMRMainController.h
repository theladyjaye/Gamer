//
//  GMRMainController.h
//  Gamer
//
//  Created by Adam Venturella on 11/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GMRMainController : UIViewController<UINavigationBarDelegate> {
	UITabBarController * tabBarController;
	UIImageView * defaultImageView;
	UIViewController * lastViewController;
}
@property(nonatomic, retain)IBOutlet UITabBarController * tabBarController;
@property(nonatomic, retain)IBOutlet UIImageView * defaultImageView;

- (void)logout;
@end
