//
//  GMRMatchListCell.h
//  Gamer
//
//  Created by Adam Venturella on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRTypes.h"

@interface GMRMatchListCell : UITableViewCell {
	UILabel * label;
	UILabel * game;
	UILabel * date;
	UILabel * platformLabel;
	UIImageView * platformColors;
	GMRPlatform platform;
	
}

@property(nonatomic, retain)IBOutlet UILabel * label;
@property(nonatomic, retain)IBOutlet UILabel * game;
@property(nonatomic, retain)IBOutlet UILabel * date;
@property(nonatomic, retain)IBOutlet UILabel * platformLabel;
@property(nonatomic, retain)IBOutlet UIImageView * platformColors;
@property(nonatomic, assign) GMRPlatform platform;

@end
