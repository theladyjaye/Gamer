//
//  GMRMatchListCell.h
//  Gamer
//
//  Created by Adam Venturella on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRTypes.h"
#import "ABTableViewCell.h"

@interface GMRMatchListCell : ABTableViewCell {
	NSString * labelString;
	NSString * gameString;
	NSString * dateString;
	NSString * platformString;
	UIImage * platformColors;
	GMRPlatform platform;
	
}

@property(nonatomic, retain) NSString * labelString;
@property(nonatomic, retain) NSString * gameString;
@property(nonatomic, retain) NSString * dateString;
@property(nonatomic, retain) NSString * platformString;
@property(nonatomic, retain) UIImage * platformColors;
@property(nonatomic, assign) GMRPlatform platform;

@end
