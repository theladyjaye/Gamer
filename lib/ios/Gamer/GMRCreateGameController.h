//
//  GMRCreateGameController.h
//  Gamer
//
//  Created by Adam Venturella on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMRMenuButton,GMRMenuButtonAltLabel;
@interface GMRCreateGameController : UIViewController {
	
	GMRMenuButton * platform;
	GMRMenuButtonAltLabel * gameAndMode;
	GMRMenuButton * availability;
	GMRMenuButton * players;
	GMRMenuButton * time;
	GMRMenuButton * description;
}
@property(nonatomic, retain) IBOutlet GMRMenuButton * platform;
@property(nonatomic, retain) IBOutlet GMRMenuButtonAltLabel * gameAndMode;
@property(nonatomic, retain) IBOutlet GMRMenuButton * availability;
@property(nonatomic, retain) IBOutlet GMRMenuButton * players;
@property(nonatomic, retain) IBOutlet GMRMenuButton * time;
@property(nonatomic, retain) IBOutlet GMRMenuButton * description;

- (IBAction)selectPlatform;
- (IBAction)selectGameAndMode;
- (IBAction)selectAvailability;
- (IBAction)selectPlayers;
- (IBAction)selectTime;
- (IBAction)selectDescription;

@end
