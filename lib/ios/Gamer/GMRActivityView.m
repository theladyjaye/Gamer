//
//  GMRActivityView.m
//  Gamer
//
//  Created by Adam Venturella on 12/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRActivityView.h"

static void drawPatternCallback(void* image, CGContextRef context)
{	
	if (image && context)
	{
		CGRect rect = { CGPointZero, {1.0, 1.0} };
		
		// Quartz 0,0 is at the lower left, where as UIKit's 0,0 is upper left, so we
		// flip the coordinate space around
		CGContextTranslateCTM(context, 0.0, 1.0);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		CGContextDrawImage(context, rect, (CGImageRef)image);
	}
}

static void releasePatternCallback(void* image)
{
	if (image)
	{
		CGImageRelease((CGImageRef)image);
	}
}

static CGPatternCallbacks ActivityViewPatternCallbacks =
{
	0, // version
	drawPatternCallback,
	releasePatternCallback
};



@implementation GMRActivityView


- (id)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:(CGRect){ { -8.0, -45.0 }, {260.0, 55.0} } ];
    
	if (self) 
	{
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
	return self;
}

- (void)transitionIn
{
	[activityView startAnimating];
	[UIView animateWithDuration:0.35 
						  delay:0.0 
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 self.transform = CGAffineTransformMakeTranslation(0.0, 50.0);
					 }
					 completion:NULL];
}


- (void)transitionOut
{
	[UIView animateWithDuration:0.35 
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 self.transform = CGAffineTransformIdentity;
					 }
					 completion:^(BOOL finished){
						 [activityView stopAnimating];
					 }];
}


- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	CGContextClearRect(context, rect);
	
	CGContextSetFillColor(context, CGColorGetComponents([UIColor blackColor].CGColor));
	//CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 6.0f);
	
	CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f), 6.0, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75].CGColor);
	
	
	// --- begin pattern
	// see: http://www.geekspiff.com/unlinkedCrap/tiledCGImage.html
	
	// because we are scaling it in the transform of the pattern, we can set everything else to 1.0 dimension wise
	// and the transform will deal with the scaling
	CGRect patternRect      = { CGPointZero, {1.0, 1.0} };
	CGImageRef patternImage = [UIImage imageNamed:@"ActivityViewPattern.png"].CGImage;
	
	CGAffineTransform transform = CGAffineTransformMakeScale(CGImageGetWidth(patternImage), 
															 CGImageGetHeight(patternImage));
	
	CGPatternRef pattern = CGPatternCreate(patternImage,
										   patternRect, 
										   transform, 
										   1.0, 
										   1.0, 
										   kCGPatternTilingConstantSpacingMinimalDistortion, 
										   true, 
										   &ActivityViewPatternCallbacks);
	
	
	CGColorSpaceRef patternColorspace = CGColorSpaceCreatePattern(NULL);
	CGContextSetFillColorSpace(context, patternColorspace);
	CGColorSpaceRelease(patternColorspace);
	CGContextSetFillPattern(context, pattern, (float[]){1.0});
	CGPatternRelease(pattern);
	
	// --- end pattern
	
	
	CGFloat inset = 8.0;
	CGRect targetRect = CGRectInset(rect, inset, inset);
	
	CGFloat minx = CGRectGetMinX(targetRect);
	CGFloat midx = CGRectGetMidX(targetRect);
	CGFloat maxx = CGRectGetMaxX(targetRect);
	
	CGFloat miny = CGRectGetMinY(targetRect);
	CGFloat midy = CGRectGetMidY(targetRect);
	CGFloat maxy = CGRectGetMaxY(targetRect);
	
	CGContextMoveToPoint(context, minx, midy);
	
	CGContextAddArcToPoint(context, minx, miny, midx, miny, 7.0);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, 7.0);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, 7.0);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, 7.0);
	
	CGContextFillPath(context);
	
	UIGraphicsPopContext();
	
	// -- Add the Text
	
	[[UIColor whiteColor] set];
	UIFont * labelFont     = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
	[@"One Moment" drawAtPoint:CGPointMake(27.0 + inset, 14.0 + inset) withFont:labelFont];
	
	// -- Add the Activity Indicator
	
	activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityView.transform = CGAffineTransformMakeScale(0.85, 0.85);
	activityView.frame = (CGRect){ {5.0 + inset, 13.0 + inset}, activityView.frame.size};
	[self addSubview:activityView];
	
}


- (void)dealloc {
	[activityView removeFromSuperview];
	[activityView release];
    [super dealloc];
}


@end
