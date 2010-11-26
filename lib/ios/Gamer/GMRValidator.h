//
//  GMRValidator.h
//  Gamer
//
//  Created by Adam Venturella on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


enum {
	GMRValidatorRequirementRequired,
	GMRValidatorRequirementOptional
};
typedef NSInteger GMRValidatorRequirement;

@class GMRForm;

@interface GMRValidator : NSObject {
	BOOL _ok;
	
	GMRForm  * form;
	NSString * key;
	NSString * message;
	GMRValidatorRequirement requirement;
}


@property(nonatomic, retain) NSString * key;
@property(nonatomic, retain) NSString * message;
@property(nonatomic, assign) GMRForm  * form;
@property(nonatomic, assign) GMRValidatorRequirement requirement;
@property(nonatomic, readonly) BOOL ok;

- (void)validate;
@end
