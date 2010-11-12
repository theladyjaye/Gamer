//
//  GMRAlertView.h
//  Gamer
//
//  Created by Adam Venturella on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GMRAlertView : UIViewController 
{
	NSString * alertTitle;
	id alertMessage;
	id<NSObject> delegate;
}

@property(nonatomic, retain) NSString * alertTitle;
@property(nonatomic, retain) id alertMessage;

- (id)initWithTitle:(NSString *)title message:(id)message delegate:(id<NSObject>)del;
- (void)show;

@end
