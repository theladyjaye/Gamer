//
//  GMRChoosePlayers.h
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRCreateGameSheet.h"

@interface GMRChoosePlayers : GMRCreateGameSheet {
	UILabel * label;
	UIPickerView * pickerView;
}
@property(nonatomic, retain) IBOutlet UILabel * label;
@property(nonatomic, retain) IBOutlet UIPickerView * pickerView;
@end
