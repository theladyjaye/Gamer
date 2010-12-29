//
//  GMRGameDetailController+Sharing.h
//  Gamer
//
//  Created by Adam Venturella on 12/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRGameDetailController.h"

@interface GMRGameDetailController(Sharing)

- (void)shareEmail;
- (void)shareFacebook;
- (void)shareTwitter;
- (void)shareCopyUrl;
- (void)sendMail:(NSString *)messageTitle message:(NSString *)messageBody to:(NSString *)email;
//-(void)modfiyMailComposeViewNavigationBar:(UINavigationBar *)sourceBar newBar:(UINavigationBar *)newBar title:(NSString *)barTitle;

@end
