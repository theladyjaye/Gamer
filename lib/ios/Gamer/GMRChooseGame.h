//
//  GMRChooseGame.h
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRCreateGameSheet.h"

@interface GMRChooseGame : GMRCreateGameSheet {
	NSArray * games;
	UILabel * gameLabel;
	UIImageView * navigationBarShadow; // assign only
}

@property(nonatomic, retain)IBOutlet UILabel * gameLabel;

@end
