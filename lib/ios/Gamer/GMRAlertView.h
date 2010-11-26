//
//  GMRAlertView.h
//  Gamer
//
//  Created by Adam Venturella on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
	GMRAlertViewStyleNotification,
	GMRAlertViewStyleConfirmation
};
typedef NSUInteger GMRAlertViewStyle;

@interface GMRAlertView : UIViewController 
{
	NSString * alertTitle;
	id alertMessage;
	id<NSObject> delegate;
	GMRAlertViewStyle style;
	NSInteger selectedButtonIndex;
	void (^callback)(GMRAlertView *);
}

@property(nonatomic, retain) NSString * alertTitle;
@property(nonatomic, retain) id alertMessage;
@property(nonatomic, readonly) GMRAlertViewStyle style;
@property(nonatomic, readonly) NSInteger selectedButtonIndex;

- (id)initWithStyle:(GMRAlertViewStyle)alertStyle title:(NSString *)title message:(id)message callback:(void (^)(GMRAlertView *))block;
- (id)initWithStyle:(GMRAlertViewStyle)alertStyle title:(NSString *)title message:(id)message delegate:(id<NSObject>)del;
- (id)initWithTitle:(NSString *)title message:(id)message delegate:(id<NSObject>)del;
- (void)show;

@end
