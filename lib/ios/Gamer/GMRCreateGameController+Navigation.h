//
//  GMRCreateGameController+Navigation.h
//  Gamer
//
//  Created by Adam Venturella on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRCreateGameController.h"

@interface GMRCreateGameController(Navigation)
- (IBAction)selectOption:(id)sender;
- (void)selectPlatform;
- (void)selectGameAndMode;
- (void)selectAvailability;
- (void)selectPlayers;
- (void)selectTime;
- (void)selectDescription;
@end
