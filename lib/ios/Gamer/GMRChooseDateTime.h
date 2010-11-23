//
//  GMRChooseDateTime.h
//  Gamer
//
//  Created by Adam Venturella on 11/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRCreateGameSheet.h"

@interface GMRChooseDateTime : GMRCreateGameSheet {
	UIDatePicker * datePicker;
	UILabel * label;
}
@property(nonatomic, retain) IBOutlet UIDatePicker * datePicker;
@property(nonatomic, retain) IBOutlet UILabel * label;

@end
