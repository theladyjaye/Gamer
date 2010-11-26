//
//  GMRFormValidator.h
//  Gamer
//
//  Created by Adam Venturella on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GMRValidator;
@interface GMRForm : NSObject {
	BOOL _ok;
	id context;
	BOOL needsValidation;
	NSMutableArray * errors;
	NSMutableArray * validators;
}

@property(nonatomic, readonly) BOOL ok;
@property(nonatomic, readonly) NSArray * errors;
@property(nonatomic, readonly) id context;

// context must be KVC
- (id)initWithContext:(id)ctx;
- (void)addValidator:(GMRValidator *)validator;
- (void)hydrateErrorMessages;
- (void)validate;
@end
