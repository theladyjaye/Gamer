//
//  GMRViewController.h
//  Gamer
//
//  Created by Adam Venturella on 11/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMRViewController : UIViewController {

}
- (void)changeViews:(UIViewController *)controller withTitle:(NSString *)title;
- (void)popViewController;
@end
