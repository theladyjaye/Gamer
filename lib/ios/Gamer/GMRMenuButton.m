//
//  GMRMenuButton.m
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRMenuButton.h"

@implementation GMRMenuButton
@synthesize backgroundImage, label, accessoryImage;

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
	
	[self setBackgroundImage:[self backgroundImageForHighlighted] forState:UIControlStateHighlighted];
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
	BOOL needsBackgroundImageUpdate;
	
	if((self.selected == NO && value) || (self.selected == YES && !value))
		needsBackgroundImageUpdate = YES;
	
	[super setSelected:value];
	
	if(needsBackgroundImageUpdate)
	{
		//self.backgroundImage.image = value ? [self backgroundImageForState:UIControlStateSelected] : [self backgroundImageForState:UIControlStateNormal];
	}
	
	if(self.accessoryImage)
	{
		if(value)
		{
			self.accessoryImage.hidden = NO;
		}
		else 
		{
			self.accessoryImage.hidden = YES;
		}

	}
		
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
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonPodBackground" ofType:@"png"]];
}

- (UIImage *)backgroundImageForClosedNormal
{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonPodBackground" ofType:@"png"]];
}

- (UIImage *)backgroundImageForHighlighted
{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonPodHighlighted" ofType:@"png"]];
}


- (void)dealloc 
{
	self.label = nil;
	self.backgroundImage = nil;
	self.accessoryImage = nil;
	[backgroundImageLookup release];
	[super dealloc];
}


@end
