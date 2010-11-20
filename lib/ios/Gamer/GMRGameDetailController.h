//
//  GMRGameDetailController.h
//  Gamer
//
//  Created by Adam Venturella on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRViewController.h"
@interface GMRGameDetailController : GMRViewController {
	UITableView * playersTableView;
	NSArray * playersForMatch;
	NSDictionary * match;
}
@property(nonatomic, retain) IBOutlet UITableView * playersTableView;
@property(nonatomic, retain) NSArray * playersForMatch;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
