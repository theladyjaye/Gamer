//
//  GMRFormatter.h
//  Gamer
//
//  Created by Adam Venturella on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMRFormatter : NSFormatter {
	void (^onInvalidCharacter)(void);
}

@property(nonatomic, retain) void (^onInvalidCharacter)(void);

-(NSString *) applyFormat:(NSString *)string withValidCharacters:(NSString *)validCharacters;
-(NSString *) applyFormat:(NSString *)string withInvalidCharacters:(NSString *)invalidCharactes;
@end
