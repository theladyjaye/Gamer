//
//  GMRAliasListCell.h
//  Gamer
//
//  Created by Adam Venturella on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"
#import "GMRTypes.h"

@interface GMRAliasListCell : ABTableViewCell {
	NSString * alias;
	GMRPlatform platform;
}
@property(nonatomic, retain)  NSString * alias;
@property(nonatomic, assign)  GMRPlatform platform;

@end
