//
//  GMRAuthenticationInputController.h
//  Gamer
//
//  Created by Adam Venturella on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMRAuthenticationController;
@interface GMRAuthenticationInputController : UIViewController<UITextFieldDelegate>
{
	UITextField * username;
	UITextField * password;
	GMRAuthenticationController * authenticationController;
}

@property(nonatomic, retain) IBOutlet UITextField * username;
@property(nonatomic, retain) IBOutlet UITextField * password;
@property(nonatomic, assign) GMRAuthenticationController * authenticationController;

- (IBAction)authenticate;
- (void)authenticationDidSucceedWithUsername:(NSString *)name andToken:(NSString *)token;
- (void)authenticationDidFail;
@end
