//
//  GMRActivityView.h
//  Gamer
//
//  Created by Adam Venturella on 12/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GMRActivityView : UIView {
	UIActivityIndicatorView * activityView;
	BOOL inTransition;
}
- (void)transitionIn;
- (void)transitionOut:(void(^)(void))complete;
- (void)realizeTransitionOut:(void(^)(void))complete;
@end
