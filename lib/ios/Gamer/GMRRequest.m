//
//  GMRRequest.m
//  Gamer
//
//  Created by Adam Venturella on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRRequest.h"
#import "GMRTypes.h"
#import "GMRUtils.h"
#import "ASIHTTPRequest.h"
#import "YAJLDocument.h"


#define API_DOMAIN @"http://hazgame.com:7331"
#define GAMER_TESTING 1

@implementation GMRRequest
@synthesize key;

- (void)execute:(NSDictionary *)options withCallback:(GMRCallback)callback
{
	NSOperationQueue * q = [[[NSOperationQueue alloc] init] autorelease];
	
	[q addOperationWithBlock:^{
		
		NSString * endpoint = [NSString stringWithFormat:@"%@%@", API_DOMAIN, [options valueForKey:@"path"]];
		
		if ([options objectForKey:@"query"] != nil) 
		{
			NSDictionary * query = (NSDictionary *) [options valueForKey:@"query"];
			endpoint = [NSString stringWithFormat:@"%@?%@", endpoint, [GMRUtils formEncodedStringFromDictionary:query]];
		}
		
		
		NSURL * url = [NSURL URLWithString:endpoint];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
		
		[request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"OAuth %@", self.key]];
		[request addRequestHeader:@"Accept"        value:@"application/json"];
		[request addRequestHeader:@"User-Agent"    value:@"HazGame Mobile"];
		
		[request setRequestMethod:[options valueForKey:@"method"]];
		[request startSynchronous];
		
		NSError * error = nil;
		YAJLDocument * json = [[[YAJLDocument alloc] initWithData:[request responseData] 
													   parserOptions:YAJLParserOptionsNone 
															   error:&error] autorelease];		
		if(error)
			NSLog(@"ER-ROAR!");
		
		
		callback([[json.root objectForKey:@"ok"] boolValue], (NSDictionary *)json.root);
	}];
	
#if GAMER_TESTING
	[q waitUntilAllOperationsAreFinished];
#endif
}


- (void)dealloc
{
	self.key = nil;
	[super dealloc];
}
@end
