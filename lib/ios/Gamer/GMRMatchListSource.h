//
//  GMRMatchListSource.h
//  Gamer
//
//  Created by Adam Venturella on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GMRMatchListSource

@property(nonatomic, readonly) BOOL matchListSourceUpdateViewOnChange;
@property(nonatomic, readonly) NSMutableArray * matches;

@end
