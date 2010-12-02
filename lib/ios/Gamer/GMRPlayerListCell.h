//
//  GMRPlayerListCell.h
//  Gamer
//
//  Created by Adam Venturella on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"

@interface GMRPlayerListCell : ABTableViewCell {
	NSString * player;
	BOOL isOwner;
}
@property(nonatomic, retain)  NSString * player;
@property(nonatomic, assign)  BOOL isOwner;
@end
