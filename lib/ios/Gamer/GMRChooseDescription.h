//
//  GMRChooseDescription.h
//  Gamer
//
//  Created by Adam Venturella on 11/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRCreateGameSheet.h"

@interface GMRChooseDescription : GMRCreateGameSheet {
	UITextView * textField;
	UITextView * proxyTextField;
}
@property (nonatomic, retain) IBOutlet UITextView * textField;
@property (nonatomic, retain) IBOutlet UITextView * proxyTextField;
@end
