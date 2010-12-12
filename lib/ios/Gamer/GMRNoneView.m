//
//  GMRNoneView.m
//  Gamer
//
//  Created by Adam Venturella on 11/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRNoneView.h"


@implementation GMRNoneView

- (id)initWithLabel:(NSString *)value
{
	self = [super initWithFrame:CGRectMake(0, 0, 320.0, 52.0)];
	if(self)
	{
		label = [value copy];
	}
	return self;
}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    // Drawing code.
	CGFloat fillGray = 244.0/255.0;
	CGFloat lineGray = 230.0/255.0;
	CGFloat textGray = 136.0/255.0;
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:fillGray green:fillGray blue:fillGray alpha:1.0].CGColor);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:lineGray green:lineGray blue:lineGray alpha:1.0].CGColor);
	
	CGContextAddRect(context, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height));
	CGContextFillPath(context);
	
	CGContextMoveToPoint(context, 0.0, rect.size.height);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
	CGContextStrokePath(context);
	
	UIFont * font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
	
	CGFloat fontHeight = font.pointSize;
    CGFloat yOffset    = (rect.size.height - fontHeight) / 2.0;
	
    CGRect textRect = CGRectMake(0, yOffset, rect.size.width, fontHeight);
	
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:textGray green:textGray blue:textGray alpha:1.0].CGColor);
    [label drawInRect:textRect 
			 withFont:font 
		lineBreakMode:UILineBreakModeClip 
			alignment:UITextAlignmentCenter];
	
	NSString * path = [[NSBundle mainBundle] pathForResource:@"ArrowUp" ofType:@"png"];
	UIImage * arrow = [UIImage imageWithContentsOfFile:path];
	[arrow drawAtPoint:CGPointMake(287.0, 8.0)];
	
}


- (void)dealloc 
{
    [label release];
	[super dealloc];
}


@end
