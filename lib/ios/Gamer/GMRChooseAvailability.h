//
//  GMRChooseAvailability.h
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRCreateGameSheet.h"
#import "GMRTypes.h"

@class GMRMenuButton;
@interface GMRChooseAvailability : GMRCreateGameSheet {
	GMRMenuButton * availabilityPublic;
	GMRMenuButton * availabilityPrivate;
	GMRMenuButton * selectedAvailability;
}
@property(nonatomic, retain) IBOutlet GMRMenuButton * availabilityPublic;
@property(nonatomic, retain) IBOutlet GMRMenuButton * availabilityPrivate;

- (IBAction)selectAvailabilityAction:(id)sender;
- (void)selectAvailability:(GMRMatchAvailablilty)value;
@end
