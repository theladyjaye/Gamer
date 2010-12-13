//
//  GMRCreateAliasController.h
//  Gamer
//
//  Created by Adam Venturella on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMRProfileController, GMRMenuButton;
@interface GMRCreateAliasController : UIViewController 
{
	GMRProfileController * profileController;	
	GMRMenuButton * platform;
	GMRMenuButton * alias;
	UIView * howItWorksView;
}


@property(nonatomic, retain) IBOutlet GMRMenuButton * platform;
@property(nonatomic, retain) IBOutlet GMRMenuButton * alias;
@property(nonatomic, retain) IBOutlet UIView * howItWorksView;

- (id)initWithProfileController:(GMRProfileController *)controller;
- (void)saveAlias;
- (void)dismissModalViewController;
@end
