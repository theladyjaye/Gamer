//
//  GMRNoneView.h
//  Gamer
//
//  Created by Adam Venturella on 11/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GMRNoneView : UIView {
	NSString * label;
	BOOL showsArrow;
}
@property(nonatomic, assign) BOOL showsArrow;
- (id)initWithLabel:(NSString *)value;
@end
