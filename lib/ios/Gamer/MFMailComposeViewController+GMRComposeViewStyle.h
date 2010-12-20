//
//  MFMailComposeViewController+GMRStyle.h
//  Gamer
//
//  Created by Adam Venturella on 12/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface MFMailComposeViewController(GMRComposeViewStyle)

+(MFMailComposeViewController *)composeViewWithTitle:(NSString *)messageTitle body:(NSString *)messageBody recipients:(NSArray *)addresses;
@end
