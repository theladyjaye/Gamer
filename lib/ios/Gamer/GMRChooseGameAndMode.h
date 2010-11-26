//
//  GMRChooseGameAndMode.h
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRCreateGameSheet.h"

@interface GMRChooseGameAndMode : GMRCreateGameSheet {
	NSArray * games;
	UILabel * gameLabel;
	UILabel * modeLabel;
	UIView * modesView;
	UITableView * modesTableView;
}

@property(nonatomic, retain)IBOutlet UILabel * gameLabel;
@property(nonatomic, retain)IBOutlet UILabel * modeLabel;
@property(nonatomic, retain)IBOutlet UIView * modesView;
@property(nonatomic, retain)IBOutlet UITableView * modesTableView;
@end
