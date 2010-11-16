//
//  GMRGameDetailController.h
//  Gamer
//
//  Created by Adam Venturella on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMRPlayersForMatch;
@interface GMRGameDetailController : UIViewController {
	UITableView * tableView;
	GMRPlayersForMatch * playersForMatch;
}
@property(nonatomic, retain) IBOutlet UITableView * tableView;
@property(nonatomic, retain) IBOutlet GMRPlayersForMatch * playersForMatch;
@end
