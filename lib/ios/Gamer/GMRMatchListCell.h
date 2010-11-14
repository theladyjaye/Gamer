//
//  GMRMatchListCell.h
//  Gamer
//
//  Created by Adam Venturella on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMRMatchListCell : UITableViewCell {
	UILabel * label;
	UILabel * game;
	UILabel * players;
	UILabel * date;
	UILabel * mode;
}

@property(nonatomic, retain)IBOutlet UILabel * label;
@property(nonatomic, retain)IBOutlet UILabel * game;
@property(nonatomic, retain)IBOutlet UILabel * players;
@property(nonatomic, retain)IBOutlet UILabel * date;
@property(nonatomic, retain)IBOutlet UILabel * mode;

@end
