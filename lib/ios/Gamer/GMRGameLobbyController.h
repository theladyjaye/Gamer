//
//  GMRGameLobbyController.h
//  Gamer
//
//  Created by Adam Venturella on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRViewController.h"

@interface GMRGameLobbyController : GMRViewController {
	UIImageView * filterCheveron;
}
@property(nonatomic, retain)IBOutlet UIImageView * filterCheveron;
- (IBAction)changeTimeFilter:(id)sender;
- (void)translateCheveronX:(CGFloat)tx;
- (void)editLobbyFilters;
@end
