//
//  GMRGameListCell.h
//  Gamer
//
//  Created by Adam Venturella on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"

@interface GMRGameListCell : ABTableViewCell {
	NSString * title;
}
@property(nonatomic, retain) NSString * title;
@end
