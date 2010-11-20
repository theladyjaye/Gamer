//
//  GMRPlayersForMatch.h
//  Gamer
//
//  Created by Adam Venturella on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRDataSource.h"

@interface GMRPlayersForMatch : NSObject<GMRDataSource, UITableViewDelegate, UITableViewDataSource> 
{
	NSArray * players;
	NSUInteger maxPlayers;
}

@property(nonatomic, assign) NSUInteger maxPlayers;
@end
