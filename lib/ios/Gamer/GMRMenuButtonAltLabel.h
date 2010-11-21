//
//  GMRMenuButtonAltText.h
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRMenuButton.h"

@interface GMRMenuButtonAltLabel : GMRMenuButton {
	UILabel * altLabel;
}
@property(nonatomic, retain) IBOutlet UILabel * altLabel;
@end
