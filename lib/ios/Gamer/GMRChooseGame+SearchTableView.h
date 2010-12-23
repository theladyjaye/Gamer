//
//  GMRChooseGame+SearchTableView.h
//  Gamer
//
//  Created by Adam Venturella on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRChooseGame.h"

@interface GMRChooseGame(SearchTableView)
- (NSInteger)numberOfSectionsInSearchResultsTableView:(UITableView *)tableView;
- (NSInteger)searchResultsTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)searchResultsTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)searchResultsTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
