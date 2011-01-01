//
//  GMRProfileController.h
//  Gamer
//
//  Created by Adam Venturella on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRViewController.h"
#import <MessageUI/MessageUI.h>

@class GMRNoneView;
@interface GMRProfileController : GMRViewController <MFMailComposeViewControllerDelegate>{
	UINavigationBar * navigationBar;
	NSMutableArray * aliases;
	UITableView * aliasTableView;
	GMRNoneView * noAliasesView;
}

@property(nonatomic, retain) NSMutableArray * aliases;
@property(nonatomic, retain) IBOutlet UINavigationBar * navigationBar;
@property(nonatomic, retain) IBOutlet UITableView * aliasTableView;

- (void)addAlias;
- (void)logout;
- (void)requestGameOrFeature;
- (void)aliasDispute;
- (IBAction) performAction:(id)sender;
- (void)noAliases;
- (void)sendMail:(NSString *)messageTitle message:(NSString *)messageBody to:(NSString *)email;

@end
