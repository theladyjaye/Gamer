//
//  GMRChoosePlatformController.h
//  Gamer
//
//  Created by Adam Venturella on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRCreateGameSheet.h"
#import "GMRTypes.h"

@class GMRMenuButton;
@interface GMRChoosePlatformController : GMRCreateGameSheet {
	GMRMenuButton * selectedButton;
	GMRMenuButton * platformBattleNet;
	GMRMenuButton * platformPlaystation2;
	GMRMenuButton * platformPlaystation3;
	GMRMenuButton * platformSteam;
	GMRMenuButton * platformWii;
	GMRMenuButton * platformXBox360;
}

@property (nonatomic, retain) IBOutlet GMRMenuButton * platformBattleNet;
@property (nonatomic, retain) IBOutlet GMRMenuButton * platformPlaystation2;
@property (nonatomic, retain) IBOutlet GMRMenuButton * platformPlaystation3;
@property (nonatomic, retain) IBOutlet GMRMenuButton * platformSteam;
@property (nonatomic, retain) IBOutlet GMRMenuButton * platformWii;
@property (nonatomic, retain) IBOutlet GMRMenuButton * platformXBox360;

- (IBAction)selectPlatformAction:(id)sender;
- (void)selectPlatform:(GMRPlatform)platform;
@end
