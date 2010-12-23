//
//  GMRLobbyFiltersController+Navigation.h
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRLobbyFiltersController.h"

@interface GMRLobbyFiltersController(Navigation) 
- (IBAction)selectOption:(id)sender;
- (void)selectPlatform;
- (void)selectGame;
@end
