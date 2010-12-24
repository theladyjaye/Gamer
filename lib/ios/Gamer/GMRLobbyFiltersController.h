//
//  GMRLobbyFiltersController.h
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRMenuButton.h"

@interface GMRLobbyFiltersController : UIViewController {
	UIViewController * owner;
	GMRMenuButton * platform;
	GMRMenuButton * game;
}
@property(nonatomic, retain) IBOutlet GMRMenuButton * platform;
@property(nonatomic, retain) IBOutlet GMRMenuButton * game;
@property(nonatomic, assign) UIViewController * owner;

- (void)applyFilter;
- (void)dismissModalViewController;
@end
