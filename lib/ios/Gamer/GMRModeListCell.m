//
//  GMRModeListCell.m
//  Gamer
//
//  Created by Adam Venturella on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRModeListCell.h"

@implementation GMRModeListCell
@synthesize title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		self.backgroundView.opaque = NO;
		self.selectedBackgroundView.opaque = NO;		
    }
	
    return self;
}

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted 
{	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIImage * backgroundImage = [UIImage imageNamed:@"ButtonPodBackground.png"];
	
	if(highlighted)
	{
		UIImage * checkboxImage  = [UIImage imageNamed:@"ButtonPodCheckbox.png"];
		CGFloat x = (backgroundImage.size.width - checkboxImage.size.width) - 1;
		[checkboxImage drawAtPoint:CGPointMake( x ,1)];
	}
	else 
	{
		CGFloat  grayColor     = 136.0/255.0;
		
		[[UIColor clearColor] set];
		CGContextFillRect(context, rect);
	
		UIFont * playerFont    = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
		UIColor * fontColor    = [UIColor colorWithRed:grayColor
												 green:grayColor
												  blue:grayColor
												 alpha:1.0];
		
		[backgroundImage drawAtPoint:CGPointMake(0, 0)];
		
		CGFloat fontHeight = playerFont.pointSize;
		CGFloat yOffset    = (rect.size.height - fontHeight) / 2.0;
		
		CGRect textRect = CGRectMake(10.0, yOffset-4.0, rect.size.width-10.0, fontHeight);
		
		CGContextSetFillColorWithColor(context, fontColor.CGColor);
		[title drawInRect:textRect 
				 withFont:playerFont 
			lineBreakMode:UILineBreakModeClip 
				alignment:UITextAlignmentLeft];
	}
	
}


- (void)dealloc 
{
    self.title = nil;
	[super dealloc];
}


@end
