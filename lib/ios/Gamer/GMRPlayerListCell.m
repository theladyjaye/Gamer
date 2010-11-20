//
//  GMRPlayerListCell.m
//  Gamer
//
//  Created by Adam Venturella on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRPlayerListCell.h"


@implementation GMRPlayerListCell
@synthesize player;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state.
}


- (void)dealloc {
	self.player = nil;
    [super dealloc];
}


@end
