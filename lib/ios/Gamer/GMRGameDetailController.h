//
//  GMRGameDetailController.h
//  Gamer
//
//  Created by Adam Venturella on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "GMRViewController.h"

@class GMRPlatformBanner, GMRMatch, OverviewController;
@interface GMRGameDetailController : GMRViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	GMRMatch * match;
	NSArray * playersForMatch;
	UITableView * playersTableView;
	
	UILabel * gameLabel;
	UILabel * descriptionLabel;
	UILabel * modeLabel;
	UILabel * scheduleTimeLabel;
	UILabel * platformLabel;
	UIView * howItWorksView;
	NSTimer * updateTimer;
	
	UIToolbar * toolbar;
	OverviewController * matchesDataSourceController;
}

@property(nonatomic, retain) IBOutlet UITableView * playersTableView;
@property(nonatomic, retain) NSArray * playersForMatch;
@property(nonatomic, retain) IBOutlet UILabel * gameLabel;
@property(nonatomic, retain) IBOutlet UILabel * descriptionLabel;
@property(nonatomic, retain) IBOutlet UILabel * modeLabel;
@property(nonatomic, retain) IBOutlet UILabel * scheduleTimeLabel;
@property(nonatomic, retain) IBOutlet UILabel * platformLabel;
@property(nonatomic, retain) IBOutlet UIView * howItWorksView;
@property(nonatomic, assign) OverviewController * matchesDataSourceController;

-(id)initWithMatch:(GMRMatch *)value;
-(void)shareGame;
-(void)cancelGame;
-(void)leaveGame;

@end
