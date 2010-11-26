//
//  GMRChooseGameAndMode+SearchTableView.h
//  Gamer
//
//  Created by Adam Venturella on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRChooseGameAndMode.h"

@interface GMRChooseGameAndMode(SearchTableView)

- (NSInteger)numberOfSectionsInSearchResultsTableView:(UITableView *)tableView;
- (NSInteger)searchResultsTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)searchResultsTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)searchResultsTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
