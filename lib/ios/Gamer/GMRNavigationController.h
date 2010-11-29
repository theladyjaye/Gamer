//
//  GMRNavigationController.h
//  Gamer
//
//  Created by Adam Venturella on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMRNavigationController : UIViewController {
	UIImageView * navigationBarShadow;
	UINavigationController * navigationController;
}
@property(nonatomic, readonly)UINavigationBar * navigationBar;

- (id)initWithRootViewController:(UIViewController *)rootViewController;
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated;
@end
