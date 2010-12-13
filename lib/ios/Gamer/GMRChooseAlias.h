//
//  GMRChooseAlias.h
//  Gamer
//
//  Created by Adam Venturella on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRCreateGameSheet.h"

@interface GMRChooseAlias : GMRCreateGameSheet {
	UITextField * aliasTextField;
}
@property(nonatomic, retain) IBOutlet UITextField * aliasTextField;
@end
