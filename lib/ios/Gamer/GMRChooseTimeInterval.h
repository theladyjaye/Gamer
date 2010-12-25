//
//  GMRChooseTimeInterval.h
//  Gamer
//
//  Created by Adam Venturella on 12/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRCreateGameSheet.h"
#import "GMRTypes.h"

@class GMRMenuButton;
@interface GMRChooseTimeInterval : GMRCreateGameSheet {
	GMRMenuButton * selectedButton; // assign only
	GMRMenuButton * interval15Min;
	GMRMenuButton * interval30Min;
	GMRMenuButton * intervalHour;
}

@property(nonatomic, retain) IBOutlet GMRMenuButton * interval15Min;
@property(nonatomic, retain) IBOutlet GMRMenuButton * interval30Min;
@property(nonatomic, retain) IBOutlet GMRMenuButton * intervalHour;

- (IBAction)selectInterval:(id)sender;
- (void)intervalSelected:(GMRTimeInterval)timeInterval;
@end
