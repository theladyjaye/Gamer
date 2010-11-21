//
//  GMRMenuButton.m
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRMenuButton.h"

@implementation GMRMenuButton
@synthesize backgroundImage, label;

-(void)awakeFromNib
{
	if(self.backgroundImage.image != nil)
	{
		[self setBackgroundImage:self.backgroundImage.image forState:UIControlStateNormal];
	}
	else 
	{
		[self setBackgroundImage:[self backgroundImageForOpenNormal] forState:UIControlStateNormal];
	}
	
	[self setBackgroundImage:[self backgroundImageForSelected] forState:UIControlStateHighlighted];
	[self setBackgroundImage:[self backgroundImageForClosedNormal] forState:UIControlStateSelected];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if(self)
	{
		backgroundImageLookup = [[NSMutableDictionary alloc] initWithCapacity:3];
		
		[self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
		[self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return self;
}

- (void)setSelected:(BOOL)value
{
	[super setSelected:value];
	self.backgroundImage.image = [self backgroundImageForState:UIControlStateSelected];
}

- (void)touchUpInside
{
	self.highlighted = NO;
	UIControlState currentState = self.selected ? UIControlStateSelected : UIControlStateNormal;
	self.backgroundImage.image = [self backgroundImageForState:currentState];
}

- (void)touchDown
{
	self.highlighted = YES;
	self.backgroundImage.image = [self backgroundImageForState:UIControlStateHighlighted];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
	[backgroundImageLookup setObject:image forKey:[NSNumber numberWithUnsignedInt:state]];
}

- (UIImage *)backgroundImageForState:(UIControlState)state
{
	return [backgroundImageLookup objectForKey:[NSNumber numberWithUnsignedInt:state]];
}

- (UIImage *)backgroundImageForOpenNormal
{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonInputOpen" ofType:@"png"]];
}

- (UIImage *)backgroundImageForClosedNormal
{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonInputClosed" ofType:@"png"]];
}

- (UIImage *)backgroundImageForSelected
{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonInputSelected" ofType:@"png"]];
}


- (void)dealloc 
{
	self.label = nil;
	self.backgroundImage = nil;
	[backgroundImageLookup release];
	[super dealloc];
}


@end
