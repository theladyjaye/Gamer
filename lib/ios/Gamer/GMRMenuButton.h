//
//  GMRMenuButton.h
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GMRMenuButton : UIControl 
{
	NSMutableDictionary * backgroundImageLookup;
	
	UIImageView * backgroundImage;
	UIImageView * accessoryImage;
	UILabel * label;
}
@property(nonatomic, retain) IBOutlet UILabel * label;
@property(nonatomic, retain) IBOutlet UIImageView * backgroundImage;
@property(nonatomic, retain) IBOutlet UIImageView * accessoryImage;

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (UIImage *)backgroundImageForState:(UIControlState)state;



- (UIImage *)backgroundImageForSelected;
- (UIImage *)backgroundImageForOpenNormal;
- (UIImage *)backgroundImageForClosedNormal;

@end
